//
//  ContentView.swift
//  test
//
//  Created by 訪客使用者 on 2024/12/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapContentView()
                .tabItem {
                    Image(systemName: "map")
                    Text("地圖")
                }
            
            ScheduleView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("行程")
                }
        }
    }
}



struct MapContentView: View {
    @State private var showingTaipeiInfo = false
    @State private var showingTaoyuanInfo = false
    @State private var showingYilanInfo = false
    @State private var showingHsinchuInfo = false
    @State private var showingMiaoliInfo = false
    @State private var showingTaichungInfo = false
    @State private var showingChanghuaInfo = false
    @State private var showingNantouInfo = false
    @State private var travelInfo = "載入中..."
    @State private var showingYunlinInfo = false
    @State private var showingChiayiInfo = false
    @State private var showingTainanInfo = false
    @State private var showingKaohsiungInfo = false
    @State private var showingPingtungInfo = false
    @State private var showingTaitungInfo = false
    @State private var showingHualienInfo = false
    
    var body: some View {
        ZStack {
            // 背景地圖圖片
            Image("taiwan_map")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            // 縣市按鈕區域
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // 北部地區
                Button(action: {
                    showingTaipeiInfo = true
                    // 當按鈕被點擊時獲取數據
                    Task {
                        do {
                            travelInfo = try await TravelDataService.fetchTravelInfo(for: "taipei")
                        } catch {
                            travelInfo = "無法載入資料：\(error.localizedDescription)"
                        }
                    }
                }) {
                    Color.green.opacity(0.0)
                }
                .frame(width: width * 0.1, height: height * 0.1)
                .position(x: width * 0.8, y: height * 0.1)
                
                Button(action: {
                    showingTaoyuanInfo = true
                }) {
                    Color.pink.opacity(0.0)
                }
                .frame(width: width * 0.1, height: height * 0.05)
                .position(x: width * 0.59, y: height * 0.12)
                
                Button(action: {
                    showingYilanInfo = true
                }) {
                    Color.brown.opacity(0.0)
                }
                .frame(width: width * 0.1, height: height * 0.1)
                .position(x: width * 0.85, y: height * 0.23)
                
                // 中部地區
                Button(action: {
                    showingHsinchuInfo = true
                }) {
                    Color.gray.opacity(0.0)
                }
                .frame(width: width * 0.1, height: height * 0.05)
                .position(x: width * 0.55, y: height * 0.2)
                
                Button(action: {
                    showingMiaoliInfo = true
                }) {
                    Color.blue.opacity(0.0)
                }
                .frame(width: width * 0.1, height: height * 0.05)
                .position(x: width * 0.4, y: height * 0.25)
                
                Button(action: {
                    showingTaichungInfo = true
                }) {
                    Color.orange.opacity(0.0)
                }
                .frame(width: width * 0.1, height: height * 0.05)
                .position(x: width * 0.35, y: height * 0.35)
                
                Button(action: {
                    showingChanghuaInfo = true
                }) {
                    Color.purple.opacity(0.0)
                }
                .frame(width: width * 0.1, height: height * 0.05)
                .position(x: width * 0.25, y: height * 0.4)
                
                Button(action: {
                    showingNantouInfo = true
                }) {
                    Color.green.opacity(0.0)
                }
                .frame(width: width * 0.2, height: height * 0.1)
                .position(x: width * 0.5, y: height * 0.45)
                
                // 南部地區
                Button(action: {
                    showingYunlinInfo = true
                }) {
                    Color.blue.opacity(0.0)
                }
                .frame(width: width * 0.15, height: height * 0.04)
                .position(x: width * 0.2, y: height * 0.48)
                
                Button(action: {
                    showingChiayiInfo = true
                }) {
                    Color.yellow.opacity(0.0)
                }
                .frame(width: width * 0.15, height: height * 0.04)
                .position(x: width * 0.2, y: height * 0.54)
                
                Button(action: {
                    showingTainanInfo = true
                }) {
                    Color.purple.opacity(0.0)
                }
                .frame(width: width * 0.15, height: height * 0.07)
                .position(x: width * 0.17, y: height * 0.62)
                
                Button(action: {
                    showingKaohsiungInfo = true
                }) {
                    Color.pink.opacity(0.0)
                }
                .frame(width: width * 0.13, height: height * 0.05)
                .position(x: width * 0.32, y: height * 0.68)
                
                Button(action: {
                    showingPingtungInfo = true
                }) {
                    Color.green.opacity(0.0)
                }
                .frame(width: width * 0.13, height: height * 0.1)
                .position(x: width * 0.3, y: height * 0.8)
                
                // 東部地區
                Button(action: {
                    showingHualienInfo = true
                }) {
                    Color.pink.opacity(0.0)
                }
                .frame(width: width * 0.1, height: height * 0.2)
                .position(x: width * 0.72, y: height * 0.45)
                
                Button(action: {
                    showingTaitungInfo = true
                }) {
                    Color.blue.opacity(0.0)
                }
                .frame(width: width * 0.15, height: height * 0.1)
                .position(x: width * 0.52, y: height * 0.7)
                
            }
        }
        .sheet(isPresented: $showingTaipeiInfo) {
            TaipeiInfoView(travelInfo: $travelInfo)
        }
        .sheet(isPresented: $showingTaoyuanInfo) {
            TaoyuanInfoView()
        }
        .sheet(isPresented: $showingYilanInfo) {
            YilanInfoView()
        }
        .sheet(isPresented: $showingHsinchuInfo) {
            HsinchuInfoView()
        }
        .sheet(isPresented: $showingMiaoliInfo) {
            MiaoliInfoView()
        }
        .sheet(isPresented: $showingTaichungInfo) {
            TaichungInfoView()
        }
        .sheet(isPresented: $showingChanghuaInfo) {
            ChanghuaInfoView()
        }
        .sheet(isPresented: $showingNantouInfo) {
            NantouInfoView()
        }
        .sheet(isPresented: $showingYunlinInfo) {
            YunlinInfoView()
        }
        .sheet(isPresented: $showingChiayiInfo) {
            ChiayiInfoView()
        }
        .sheet(isPresented: $showingTainanInfo) {
            TainanInfoView()
        }
        .sheet(isPresented: $showingKaohsiungInfo) {
            KaohsiungInfoView()
        }
        .sheet(isPresented: $showingPingtungInfo) {
            PingtungInfoView()
        }
        .sheet(isPresented: $showingTaitungInfo) {
            TaitungInfoView()
        }
        .sheet(isPresented: $showingHualienInfo) {
            HualienInfoView()
        }
    }
}

struct TaipeiInfoView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var travelInfo: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("台北旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("上午：文化與歷史的結合")
                    
                    attractionView(
                        title: "1. 台北故宮博物院",
                        highlights: "台北故宮博物院是世界四大博物館之一，擁有豐富的中華文化珍品，從古代文物到書畫藝術，是了解中國歷史與文化的最佳場。",
                        time: "建議時間：約1.5至2小時",
                        food: "美食建議：參觀完博物院後，可以在博物院內的御茶苑享受一杯茶或輕食，品味中式茶道。"
                    )
                    
                    attractionView(
                        title: "2. 士林夜市（白天）",
                        highlights: "士林夜市是台北最著的夜市之一，白天可以選擇到附近的士林市場逛逛，這裡有很多傳統台灣小吃。",
                        food: "美食推薦：士林夜市的大餅包小餅豪大大雞排、珍珠奶茶等，都是當地人和遊客必試的小吃。"
                    )
                }
                
                Group {
                    sectionHeader("中午：台北的傳統美食")
                    
                    attractionView(
                        title: "3. 台北車站附近的眷村美",
                        highlights: "台北車站周邊有很多傳統的眷村美食，可以品嘗到經典的台灣小吃。",
                        food: """
                        美食推薦：
                        • 永和豆漿大王：台灣的早餐文化非常豐富，來這裡可以嘗試鹹豆漿、油條、蛋餅等經典台灣早餐。
                        • 桂林蚵仔麵線：如果你喜歡海鮮，可以嘗試這家名的蚵仔麵線，鮮蚵與濃郁的湯底讓人難忘。
                        """
                    )
                }
                
                Group {
                    sectionHeader("下午：街頭小吃與時尚購物")
                    
                    attractionView(
                        title: "5. 東區購物特色小吃",
                        highlights: "台北的東區是時尚購物與美食的天堂。你可以在這裡體驗到台灣的流行文化，並且隨處可見多精緻的餐廳和咖啡廳。",
                        food: """
                        推薦景點：
                        • 信義區的微風廣場：這裡有許多時尚品牌，逛街累了也可以在這裡享用高級餐點。
                        • 誠品書店信義店：如果你喜歡文藝氛圍，可以進去誠品書店，這不僅賣書，還許多特色設計商品。
                        """
                    )
                }
                
                // ... 可以繼續添加更多時段的景點 ...
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil, food: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if let food = food {
                Text(food)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct TaoyuanInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("桃園旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("桃園美食推薦")
                    
                    attractionView(
                        title: "1. 桃園老街",
                        highlights: """
                        桃園老街是一個融合台灣傳統與現代的小吃天堂。這裡特色小吃包括：
                        • 蚵仔煎：外脆內嫩，醬料調味獨特
                        • 珍珠奶茶：國際知名的手搖飲料
                        • 炸鮮奶：外脆內，口感特別
                        """
                    )
                    
                    attractionView(
                        title: "2. 大溪",
                        highlights: """
                        大溪是桃園的歷史重鎮，特推薦：
                        • 大溪豆干：無論燒烤還是滷味都很受歡迎
                        • 芋圓：口感滑嫩，搭配糖水或紅豆
                        """
                    )
                }
                
                Group {
                    sectionHeader("推薦行程")
                    
                    attractionView(
                        title: "Day 1：桃園市區探索與古蹟巡禮",
                        highlights: """
                        上午：桃園老街 - 品嘗當地美食，選購紀念品
                        中午：大溪豆干與芋圓
                        下午：大溪老與大溪橋
                        晚上：中壢夜市
                        """
                    )
                    
                    attractionView(
                        title: "Day 2：自然景觀與輕鬆健行",
                        highlights: """
                        上午：蓮池潭
                        中午：慈湖
                        下午：觀音山健行
                        晚上：觀音區海鮮晚餐
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct YilanInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("宜蘭旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：宜蘭市區 & 東北角")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 宜蘭羅東動公園：享受清晨空氣，適合晨跑或散步
                        • 宜蘭設治紀念館：了解宜蘭歷史與文化
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 宜蘭傳藝中心：藝術展覽、文化活動、手作工坊
                        • 蘭陽博物館：了解宜蘭歷史地理欣賞現代建築
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：東部海岸與大自然")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 梅花湖：晨間散步、單車環湖
                        • 頭城老街：品嚐在地小吃，如頭城鹹粥、草仔粿
                        """,
                        time: "建議時間：早上 8:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 大溪漁港：欣賞海景、品嚐海鮮
                        • 金車伯朗咖啡園：參觀咖啡製作、品嚐咖啡
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "小吃",
                        highlights: """
                        • 宜蘭米粉：口感順滑湯頭鮮美
                        • 蔥油餅：外皮酥脆，蔥香四溢
                        • 宜蘭鴨肉飯：鮮嫩多汁的傳統美食
                        • 豆腐鍋：宜蘭特色家常菜
                        • 花生冰淇淋：香濃特色甜點
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct HsinchuInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("新竹旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：新竹市區探索與古蹟巡禮")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 新竹市立影像博物館：原為新竹火車站，具有濃厚歷史氛圍
                        • 新竹城隍廟：新竹最具代表性的宗教場所，周圍有許多古色古香的商店與小吃
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 新竹文化創意產業園區：建自舊工廠區，現為文創園區
                        • 新竹動物園：台灣最早的動物園之一，保留多歷史建築
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：新竹周邊自然景點")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 青草湖：湖泊周圍有自然步道，適合散步或騎腳踏車
                        • 風櫃嘴：登山健行好去處，可賞壯麗山景
                        """,
                        time: "建議時間：早上 8:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 竹東老街：保存完好的古老街道，有許多古早味小店
                        • 內灣老街：懷舊風情，木造建築與特色小吃
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食薦")
                    
                    attractionView(
                        title: "特色小吃",
                        highlights: """
                        • 新竹米粉：細緻有彈性，搭配清淡高湯
                        • 貢丸湯：Q彈鮮美，在地特色
                        • 新竹擔仔麵：濃郁在地味
                        • 乾麵：獨特醬料搭配
                        • 花生冰淇淋：新竹特有甜點
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct MiaoliInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("苗栗旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：苗栗市區與周邊古蹟探索")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 苗栗火車站 & 苗栗老街古老車站建築，傳統小店與客家手工藝品
                        • 苗栗客家文化館：了解客家文化、歷史與藝術
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 三義木雕街：著名木雕工藝重鎮，可購買手工藝品
                        • 鯉魚潭：風景如畫的湖泊，適合散步與攝影
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：苗栗的自然景觀與山城之旅")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 大湖草莓園，冬季可採草莓，品嚐草莓美食
                        • 公館老街：古老建築與傳統商店，適合拍照
                        """,
                        time: "建議時間：早上 8:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 尖石風景區：美麗山景與登山步道
                        • 南庄老街：懷舊氛圍，可品嚐特色小吃
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色美食",
                        highlights: """
                        • 客家炒：經典客家料理，搭配豬肉、蝦米、酸菜
                        • 擂茶：客家特色飲品，營養豐富
                        • 客家米粉：滑順的米粉搭配清爽湯頭
                        • 草莓冰淇淋：冬季限定，大湖特產
                        • 竹筒飯：米飯與肉類在竹筒中蒸煮，香氣四溢
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct TaichungInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("台中旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：台中市區與藝術文化探索")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 台中公園：市區最大歷史公園，擁有湖泊和日式庭園
                        • 國立台灣美術館：重要的現代藝術博物館
                        • 草悟道：綠意大道，連接多個文化景點
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 一中街：購物天堂與小吃集散地
                        • 彩虹眷村：色彩繽紛的藝術社區，網紅打卡熱點
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：台中周邊自然景點")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 高美濕地：著名自然景點，適合觀察野生動物
                        • 武陵農場：以櫻花、梅花聞名的自然景點
                        """,
                        time: "建議時間：早上 8:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 東勢林場：熱門登山健行景點
                        • 大甲鎮瀾宮：具代表性的媽祖廟宇
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("吃美食推薦")
                    
                    attractionView(
                        title: "特色小吃",
                        highlights: """
                        • 台中鹽酥雞：外脆內嫩，搭配蒜味和香料
                        • 大腸包小腸：夜市必試小吃
                        • 炸花枝丸：受歡迎的炸物小吃
                        • 台中珍珠奶茶：珍珠奶茶發源地之一
                        • 台中牛肉火鍋：湯頭濃郁，選用新鮮牛肉
                        • 客家圓圓粿：客家特色小吃
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct ChanghuaInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("彰化旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：彰化市區與古蹟文化探索")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 鹿港老街：彰化最具代表性的歷史街區，古建築保存完好
                        • 鹿港文化村：結合傳統文化和現代藝術，展示傳統工藝
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 八卦山大佛：彰化市最具代表性景點，可俯瞰市區
                        • 彰化遊覽：參觀歷史建築，如彰化文物館
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：彰化周邊自然景點與休閒體驗")
                    
                    attractionView(
                        title: "上午行程",
                        highlights: """
                        • 田尾公路花園：綠意盎然的園區，四季花開不斷
                        • 花卉市場：種類繁多的花卉市場，價格實惠
                        """,
                        time: "建議時間：早上 8:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午行程",
                        highlights: """
                        • 溪州大草原：廣闊的草原，適合散步、野餐
                        • 南瑤宮：知名媽祖廟，建築壯觀
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色小吃",
                        highlights: """
                        • 奄仔麵線：湯頭清淡，搭配豬肝、豬腳或蝦仁
                        • 大腸包小腸：經典小吃，香腸裹入大腸內
                        • 彰化炒米粉：金黃香脆，配料豐富
                        • 彰化珍珠奶茶：珍珠奶茶發源地之一
                        • 滷味：滷水香濃風味獨特
                        • 彰化牛肉火鍋：湯底濃郁，選材新鮮
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct NantouInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("南投旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("Day 1：南投市區與名勝點")
                    
                    attractionView(
                        title: "上午：日月潭",
                        highlights: """
                        台灣最大的湖泊，可以：
                        • 搭乘遊艇遊湖，欣賞湖光山色
                        • 騎腳踏車繞湖
                        • 參觀文武廟和玄光寺
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：九族文化村",
                        highlights: """
                        集文化、娛樂、自然景觀於一體的園區：
                        • 了解台灣原住民文化
                        • 觀賞原住民表演
                        • 體驗遊樂設施
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("Day 2：中部山區自然與文化探索")
                    
                    attractionView(
                        title: "上午：清境農場",
                        highlights: """
                        • 壯麗的高山景色和可愛的綿羊
                        • 參加草原餵羊活動
                        • 登山健行、觀賞日出
                        """,
                        time: "建議時間：早上 8:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：草屯福田村",
                        highlights: """
                        • 富有歷史的傳統村落
                        • 台灣原住民文化特色
                        • 手工藝品和在地美食
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("Day 3：小鎮與鄉下美食之旅")
                    
                    attractionView(
                        title: "上午：集集鎮",
                        highlights: """
                        • 搭乘集集小火車
                        • 欣賞鄉間稻田和山景
                        • 漫遊集集老街
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：埔里酒廠",
                        highlights: """
                        • 百年歷史酒廠
                        • 了解台灣酒文化
                        • 參觀酒過程
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色美食",
                        highlights: """
                        • 日月潭阿薩姆紅茶：香醇濃郁，搭配茶葉蛋
                        • 山產料理：山豬肉、香菇炒蛋、野菜
                        • 集集米粉湯：湯頭鮮美，搭配竹筍和牛肉
                        • 埔里米酒與高粱酒：當地特產
                        • 傳統小吃：炸花枝、碗粿、臭豆腐
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct YunlinInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("雲林旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：宗教文化與美食之旅")
                    
                    attractionView(
                        title: "上午：北港朝天宮",
                        highlights: """
                        • 參拜歷史悠久的媽祖廟
                        • 感受濃厚的宗教文化氛圍
                        • 探索附近的老街，欣賞特色建築
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：鎮安宮五年千歲祖廟主題公園",
                        highlights: """
                        • 參觀主題公園，拍照打卡70處造景
                        • 特別推薦侏羅紀世界區域
                        • 適合親子和拍照愛好者
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                    
                    attractionView(
                        title: "晚上：虎尾夜市",
                        highlights: """
                        品嚐各種在地小吃：
                        • 肯得利香雞排
                        • 蚵仔煎
                        • 其他特色小吃
                        """,
                        time: "建議時間：晚上 6:00 - 9:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：自然與親子樂園")
                    
                    attractionView(
                        title: "上午：劍湖山世界主題樂園",
                        highlights: """
                        • 體驗多樣化的遊樂設施
                        • 適合家庭與朋友同遊
                        • 園內提供多種餐飲選擇
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：古坑綠色隧道與華山小天梯",
                        highlights: """
                        • 綠色隧道騎自行車，享受自然風光
                        • 挑戰小天梯與情人橋
                        • 欣賞壯麗山景
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("第三天：文化體驗與伴手禮購買")
                    
                    attractionView(
                        title: "上午：西螺大橋與西螺老街",
                        highlights: """
                        • 拍攝大橋壯觀景象
                        • 漫步老街，欣賞傳統建築
                        • 品嚐西螺麻糬大王的手工麻糬
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：口湖鄉好蝦冏男社區",
                        highlights: """
                        • 參觀養殖場
                        • 體驗捕蝦樂趣
                        • 享用新鮮現做的蝦料理
                        • 可選擇前往成龍濕地，欣賞生態之美
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("住宿推薦")
                    
                    attractionView(
                        title: "住宿選擇",
                        highlights: """
                        第一晚：
                        • 虎尾鎮斗六市的民宿或旅館
                        
                        第二晚：
                        • 斗六市區的酒店
                        • 古坑鄉特色民宿
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct ChiayiInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("嘉義旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：嘉義市區文化與美食探索")
                    
                    attractionView(
                        title: "上午：嘉義市文化之旅",
                        highlights: """
                        • 嘉義文化路夜市：體驗地道小吃和特色商店
                        • 嘉義市博物館：了解嘉義歷史和文化
                        • 嘉義火車站與老街：參觀歷史悠久的車站，漫遊老街
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：阿里山森林遊樂區",
                        highlights: """
                        • 搭乘阿里山森林鐵路
                        • 探訪森林步道
                        • 欣賞壯麗山景
                        • 觀賞阿里山日出（建議隔日早起）
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：嘉義周邊自然景點與美食體驗")
                    
                    attractionView(
                        title: "上午：檜意森活村與梅山茶區",
                        highlights: """
                        • 檜意森活村：參觀檜木建築，體驗檜木文化
                        • 梅山茶區：參觀茶園，品嚐高山茶
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：布袋戲文化村",
                        highlights: """
                        • 了解布袋戲歷史和藝術
                        • 觀賞布袋戲表演
                        • 參觀布袋戲偶展覽
                        """,
                        time: "建議時間：下午 2:00 - 5:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色美食",
                        highlights: """
                        • 火雞肉飯：嘉義代表性美食，滷汁香濃
                        • 雞肉飯：肉質鮮嫩，湯頭香濃
                        • 阿里山茶葉：四大高山茶之一，清香花香味
                        • 檜木竹筒飯：統美食，香氣撲鼻
                        • 梅山茶餐廳：創意茶葉料理
                        • 嘉義豆腐：多種料理方式，豆腐鍋最受歡迎
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct TainanInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("台南旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：台南市區歷史文化與經典美食探索")
                    
                    attractionView(
                        title: "上午：安平區探索",
                        highlights: """
                        • 安平古堡：17世紀荷蘭東印度公司遺址，可俯瞰海岸線
                        • 安平老街：充滿歷史氛圍，有傳統小店和小吃
                        • 品嚐安平豆花、蝦餅和鹽水雞
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：歷史建築巡禮",
                        highlights: """
                        • 赤崁樓：重要歷史建築，原為荷蘭防禦工事
                        • 台南孔廟：台灣最古老的孔廟，建於1665年
                        • 神農街：特色古、文創店和咖啡廳
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：台南周邊自然景點與美食體驗")
                    
                    attractionView(
                        title: "上午：生態之旅",
                        highlights: """
                        • 鹽水溪：生態景點，觀察鳥類和水生植物
                        • 四草綠色隧道：紅樹林環繞的水上步道
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：文化藝術之旅",
                        highlights: """
                        • 大內原住民文化村：了解原住民歷史文化
                        • 台南美術館：現代藝術展覽
                        • 神農街夜遊：體驗老街風情
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色小吃",
                        highlights: """
                        • 台南擔仔麵：代表性小吃，湯頭濃郁
                        • 牛肉湯：清淡鮮美，牛肉嫩滑
                        • 安平豆花：傳統甜品，滑嫩可口
                        • 鹽水雞：夜市美食，搭配香料和酸菜
                        • 蚵仔煎：經典小吃，酥脆美味
                        • 大腸包小腸：夜市必試，外脆內嫩
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct KaohsiungInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("高雄旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：高雄市區歷史與文化探索")
                    
                    attractionView(
                        title: "上午：蓮池潭與哈瑪星藝術區",
                        highlights: """
                        蓮池潭：
                        • 優美的自然景觀和濃厚的宗教氛圍
                        • 龍虎塔，可俯瞰全景
                        • 寧靜的環境，適合晨間遊覽
                        
                        哈瑪星藝術區：
                        • 充滿藝術氣息的創意小店和畫廊
                        • 舊鐵道改建的文化藝術區
                        • 年輕人喜愛的聚集地
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：寺廟與藝術探索",
                        highlights: """
                        • 春秋閣與龍虎塔：精美的寺廟建築
                        • 高雄市立美術館：現代化藝術展覽
                        • 六合夜市：經典夜市美食體驗
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：高雄的自然景點與現代力")
                    
                    attractionView(
                        title: "上午：旗津之旅",
                        highlights: """
                        • 旗津海濱：騎腳踏車、漫步沙灘
                        • 旗津天后宮：重要宗教場所
                        • 品嚐新鮮海鮮
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：藝術與科技探索",
                        highlights: """
                        • 駁二藝術特區：當代藝術展覽
                        • 高雄草衙飛行器文化村：航空文化與科技展示
                        • 85大樓觀景台：欣賞高雄夜景
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色美食",
                        highlights: """
                        • 高雄海產：蚵仔煎、燒烤蚵仔、海鮮粥
                        • 牛肉湯：鮮美湯頭，嫩滑牛肉
                        • 大腸包小腸：夜市經典小吃
                        • 鹽水雞：搭配香料，口感獨特
                        • 珍珠奶茶：經典台灣飲品
                        • 擔仔麵：濃郁湯頭，配料豐富
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct PingtungInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("屏東旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：探索屏東自然美景與鄉村風情")
                    
                    attractionView(
                        title: "上午：墾丁國家公園與恆春古城",
                        highlights: """
                        墾丁國家公園：
                        • 南灣、白沙灣、船帆石等著名景點
                        • 可進行浮潛、滑浪風帆等水上活動
                        
                        恆春古城：
                        • 清代時期的城牆和門樓
                        • 特色小店與手工藝品
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：白沙灣與車城",
                        highlights: """
                        • 白沙灣：潔白細緻的沙灘，適合水上活動
                        • 墾丁綠島或海生館：了解海洋生態
                        • 車城海角七號影像基地：欣賞浪漫日落
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：原住民文化與自然景點")
                    
                    attractionView(
                        title: "上午：原住民文化體驗",
                        highlights: """
                        泰武部落：
                        • 參加文化體驗活動（編織、陶藝、傳統舞蹈）
                        • 了解原住民歷史與生活
                        
                        玳瑁灣：
                        • 清澈海水，適合潛水和浮潛
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：溫泉與牧場體驗",
                        highlights: """
                        • 四重溪溫泉：享受無色無味的溫泉水
                        • 草埔牧場：牧場體驗，品嚐乳製品
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色美食",
                        highlights: """
                        • 墾丁海鮮：鹽焗螃蟹、生魚片、蚵仔煎、炸蝦餅
                        • 屏東鳳梨：新鮮鳳梨或鳳梨酥
                        • 芒果冰：夏季必試甜品
                        • 原住民料理：山豬肉、竹筒飯、野菜
                        • 牛奶冰淇淋：草埔牧場特製
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct TaitungInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("台東旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：探索台東的自然景觀與文化")
                    
                    attractionView(
                        title: "上午：熱氣球與三仙台",
                        highlights: """
                        台東熱氣球嘉年華（七月到八月）：
                        • 搭乘熱氣球欣賞山海美景
                        • 觀賞各式色彩繽紛的熱氣球
                        
                        三仙台：
                        • 美麗的海岸風光
                        • 古老的石橋和小島景觀
                        • 清澈海水和寬闊沙灘
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：文化與藝術探索",
                        highlights: """
                        鹿野高台：
                        • 廣闊草原和壯麗山景
                        • 原住民文化體驗
                        • 熱氣球起飛地點
                        
                        台東美術館：
                        • 當代藝術展覽
                        • 在地藝術家作品
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：探索台東的自然景點與原住民文化")
                    
                    attractionView(
                        title: "上午：池上與太麻里",
                        highlights: """
                        池上鄉：
                        • 品嚐著名的池上便當
                        • 參觀稻田風光
                        
                        太麻里金針山：
                        • 欣賞金針花海（季節限定）
                        • 壯麗的山景
                        """,
                        time: "建議時間：早上 8:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：綠島一日遊",
                        highlights: """
                        • 浮潛和潛水活動
                        • 參觀綠島燈塔
                        • 人權文化園區
                        • 體驗綠島溫泉
                        
                        替代行程：
                        • 參觀成功鎮小野柳
                        • 欣賞奇特岩石景觀
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色美食",
                        highlights: """
                        • 台東海鮮：鮮蚵煎、炸花枝、海鮮湯
                        • 池上便當：當地特產米飯配滷肉、炸雞
                        • 竹筒飯：原住民傳統美食
                        • 台東小吃：炸包子、滷味、珍珠奶茶
                        • 金針花料理：金針花炒蛋、金針花泡菜（季節限定）
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

struct HualienInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("花蓮旅遊指南")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button("關閉") {
                        dismiss()
                    }
                }
                .padding()
                
                Group {
                    sectionHeader("第一天：探索花蓮的自然美景與文化")
                    
                    attractionView(
                        title: "上午：太魯閣國家公園",
                        highlights: """
                        台灣最知名的國家公園之一：
                        • 燕子口、長春祠
                        • 砂卡礑步道：美麗的懸崖景觀
                        • 白楊步道
                        • 太魯閣大理石峽谷：壯觀的岩壁景觀
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：文化與海景探索",
                        highlights: """
                        花蓮文化創意產業園區：
                        • 手工藝品店與藝術展覽
                        • 文創商品與咖啡廳
                        
                        七星潭：
                        • 壯麗海景與美麗海灘
                        • 適合散步、騎腳踏車
                        • 可參加水上活動
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("第二天：花蓮的自然景點與鄉村風情")
                    
                    attractionView(
                        title: "上午：瑞穗牧場與美術館",
                        highlights: """
                        瑞穗牧場：
                        • 體驗餵牛、擠牛奶
                        • 品嚐瑞穗牛奶和牛奶冰淇淋
                        • 欣賞牧場風景
                        
                        花蓮縣立美術館：
                        • 當代藝術展覽
                        • 特展活動
                        """,
                        time: "建議時間：早上 9:00 - 12:00"
                    )
                    
                    attractionView(
                        title: "下午：藝術與生態之旅",
                        highlights: """
                        花蓮石雕藝術村：
                        • 欣賞石雕藝術作品
                        • 體驗石雕製作
                        
                        立川漁場：
                        • 體驗釣魚活動
                        • 品嚐鮮魚料理
                        • 觀賞水鳥生態
                        """,
                        time: "建議時間：下午 2:00 - 6:00"
                    )
                }
                
                Group {
                    sectionHeader("必吃美食推薦")
                    
                    attractionView(
                        title: "特色美食",
                        highlights: """
                        • 炸花枝：外脆內嫩，搭配特製醬料
                        • 大腸包小腸：夜市經典小吃
                        • 池上便當：著名的便當料理
                        • 花蓮扁食：特色水餃
                        • 花蓮綠豆湯：解暑甜品
                        • 牛奶冰淇淋：瑞穗牧場特製
                        • 原住民料理：山豬肉、竹筒飯、野菜
                        """
                    )
                }
            }
            .padding()
        }
    }
    
    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .bold()
            .padding(.vertical, 8)
    }
    
    private func attractionView(title: String, highlights: String, time: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .bold()
            
            Text(highlights)
                .font(.body)
            
            if let time = time {
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

#Preview {
    ContentView()
}
