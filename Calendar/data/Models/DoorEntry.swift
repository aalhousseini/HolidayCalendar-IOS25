//
//  SwiftUIView.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//

import SwiftUI
import SwiftData

@Model
 class DoorEntry {
    @Attribute(.unique) var id: UUID
    var quote: String
    var imageData: Data?
    var date: Date // Use Date for timestamps

    init(id: UUID = UUID(), quote: String, imageData: Data? = nil, date: Date = Date()) {
        self.id = id
        self.quote = quote
        self.imageData = imageData
        self.date = date
    }
}
