//
//  CalendarModel.swift
//  Calendar
//
//  Created by Hanno Wiesen on 17.01.25.
//
import SwiftUI

struct CalendarCodable: Codable {
    var name: String?
    var startDate: Date?
    var doors: [DoorCodable]?
}
