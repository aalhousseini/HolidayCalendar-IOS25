//
//  DoorListView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//

import SwiftUI
import SwiftData

struct DoorListView: View {
    @Query var doors: [DoorEntry]

    var body: some View {
        List(doors) { door in
            VStack(alignment: .leading) {
                Text(door.quote)
                    .font(.headline)
                
                // If 'date' is non-optional, use it directly
                Text("Date: \(door.date.formatted())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}


#Preview {
    DoorListView()
}
