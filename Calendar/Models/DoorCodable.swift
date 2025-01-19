//
//  CalendarDOOR.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 10.01.25.
//

import Foundation

struct DoorCodable: Codable {
    var number: Int?
    var unlockDate: Date?
    var isCompleted: Bool?
    var challenge: String?
}
