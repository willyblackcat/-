import SwiftUI
import UserNotifications

class ScheduleViewModel: ObservableObject {
    @Published var schedules: [Schedule] = []
    @Published var showingAddSheet = false
    
    // 預定義的顏色選項
    let colorOptions: [(name: String, color: Color)] = [
        ("blue", .blue),
        ("red", .red),
        ("green", .green),
        ("purple", .purple),
        ("orange", .orange),
        ("pink", .pink)
    ]
    
    // 根據顏色名稱獲取對應的 Color
    func getColor(for name: String) -> Color {
        if let color = colorOptions.first(where: { $0.name == name }) {
            return color.color
        }
        return .blue // 默認顏色
    }
    
    func addScheduleItem(_ item: ScheduleItem, for date: Date) {
        let calendar = Calendar.current
        if let index = schedules.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            // 如果該日期已存在行程，則添加新項目
            schedules[index].items.append(item)
            // 按時間排序
            schedules[index].items.sort { $0.time < $1.time }
        } else {
            // 如果該日期還沒有行程，創建新的
            let newSchedule = Schedule(date: date, items: [item])
            schedules.append(newSchedule)
            // 按日期排序
            schedules.sort { $0.date < $1.date }
        }
        scheduleNotification(for: item)
    }
    
    func scheduleNotification(for item: ScheduleItem) {
        let content = UNMutableNotificationContent()
        content.title = "行程提醒"
        content.body = "現在是時候前往：\(item.location)"
        content.sound = .default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: item.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var selectedDate = Date()
    @State private var location = ""
    @State private var scheduleTime = Date()
    @State private var notes = ""
    @State private var selectedColorName = "blue"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.schedules.sorted(by: { $0.date < $1.date })) { schedule in
                    Section(header: Text(schedule.date.formatted(date: .long, time: .omitted))) {
                        ForEach(schedule.items.sorted(by: { $0.time < $1.time })) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.location)
                                        .font(.headline)
                                    Text("時間：\(item.time.formatted(date: .omitted, time: .shortened))")
                                    if !item.notes.isEmpty {
                                        Text("備註：\(item.notes)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                                
                                // 導航按鈕
                                Button(action: {
                                    if let encodedLocation = item.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                       let url = URL(string: "http://maps.apple.com/?daddr=\(encodedLocation)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.blue)
                                        .font(.title2)
                                }
                                
                                // 刪除按鈕
                                Button(action: {
                                    if let scheduleIndex = viewModel.schedules.firstIndex(where: { $0.id == schedule.id }),
                                       let itemIndex = viewModel.schedules[scheduleIndex].items.firstIndex(where: { $0.id == item.id }) {
                                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
                                        viewModel.schedules[scheduleIndex].items.remove(at: itemIndex)
                                        if viewModel.schedules[scheduleIndex].items.isEmpty {
                                            viewModel.schedules.remove(at: scheduleIndex)
                                        }
                                    }
                                }) {
                                    Image(systemName: "trash.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.title2)
                                }
                                .padding(.leading, 8)
                            }
                            .padding()
                            .background(viewModel.getColor(for: item.colorName).opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .navigationTitle("行程規劃")
            .toolbar {
                Button("新增行程") {
                    viewModel.showingAddSheet = true
                }
            }
            .sheet(isPresented: $viewModel.showingAddSheet) {
                NavigationView {
                    Form {
                        DatePicker("日期", selection: $selectedDate, displayedComponents: .date)
                        TextField("地點", text: $location)
                        DatePicker("時間", selection: $scheduleTime, displayedComponents: .hourAndMinute)
                        TextField("備註", text: $notes)
                        
                        // 顏色選擇器
                        Picker("顏色標記", selection: $selectedColorName) {
                            ForEach(viewModel.colorOptions, id: \.name) { option in
                                HStack {
                                    Circle()
                                        .fill(option.color)
                                        .frame(width: 20, height: 20)
                                    Text(option.name.capitalized)
                                }
                                .tag(option.name)
                            }
                        }
                    }
                    .navigationTitle("新增行程")
                    .navigationBarItems(
                        leading: Button("取消") {
                            viewModel.showingAddSheet = false
                        },
                        trailing: Button("儲存") {
                            let newItem = ScheduleItem(
                                location: location,
                                time: scheduleTime,
                                notes: notes,
                                colorName: selectedColorName
                            )
                            viewModel.addScheduleItem(newItem, for: selectedDate)
                            viewModel.showingAddSheet = false
                            location = ""
                            notes = ""
                            selectedColorName = "blue" // 重置為默認顏色
                        }
                        .disabled(location.isEmpty)
                    )
                }
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
} 
