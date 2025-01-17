//
//  CalendarDOOR.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 10.01.25.
//

import Foundation
import SwiftData


@Model
class Door: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var number: Int
    var date: Date
    var isOpened: Bool = false
    var quote: String?
    var image: Data?
    var challenge: Challenge?
    @Relationship(inverse: \CalendarModel.doors) var calendar: CalendarModel?
    
    init(id: UUID = UUID(), number: Int, date: Date, isOpened: Bool, quote: String? = nil, image: Data? = nil, challenge: Challenge? = nil, calendar: CalendarModel? = nil) {
        self.id = id
        self.number = number
        self.date = date
        self.isOpened = isOpened
        self.quote = quote
        self.image = image
        self.challenge = challenge
        self.calendar = calendar
    }
}
