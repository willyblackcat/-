import Foundation
import SwiftUI

struct Schedule: Identifiable, Codable {
    let id: UUID
    var date: Date
    var items: [ScheduleItem]
    
    init(id: UUID = UUID(), date: Date, items: [ScheduleItem] = []) {
        self.id = id
        self.date = date
        self.items = items
    }
}

struct ScheduleItem: Identifiable, Codable {
    let id: UUID
    var location: String
    var time: Date
    var notes: String
    var colorName: String
    
    init(id: UUID = UUID(), location: String, time: Date, notes: String, colorName: String = "blue") {
        self.id = id
        self.location = location
        self.time = time
        self.notes = notes
        self.colorName = colorName
    }
} 