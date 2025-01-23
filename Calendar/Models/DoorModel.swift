//
//  CalendarDOOR.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 10.01.25.
//

import Foundation
import SwiftData

@Model
class DoorModel: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var number: Int
    var unlockDate: Date
    var isCompleted: Bool
    var quote: String?
    var image: Data?
    var challenge: String
    @Relationship(inverse: \CalendarModel.doors) var calendar: CalendarModel?
    var isImported: Bool = false
    
    var isLocked: Bool {
        return unlockDate > Date()
    }
    
    init(number: Int, unlockDate: Date, quote: String? = nil, image: Data? = nil, challenge: String, calendar: CalendarModel? = nil) {
        self.number = number
        self.unlockDate = unlockDate
        self.quote = quote
        self.image = image
        self.challenge = challenge
        self.calendar = calendar
        self.isCompleted = false
    }
}
