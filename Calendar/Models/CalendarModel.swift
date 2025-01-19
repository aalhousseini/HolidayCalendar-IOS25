//
//  CalendarModel.swift
//  Calendar
//
//  Created by Hanno Wiesen on 17.01.25.
//
import SwiftUI
import SwiftData

@Model
class CalendarModel: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var startDate: Date
    var doors: [DoorModel]

    init(name: String, startDate: Date, doors: [DoorModel] = []) {
        self.name = name
        self.startDate = startDate
        self.doors = doors
    }
}
