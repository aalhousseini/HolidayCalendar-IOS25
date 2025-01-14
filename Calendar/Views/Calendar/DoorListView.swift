//
//  DoorListView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//

import SwiftUI
import SwiftData

struct DoorListView: View {
    @Query var doors: [Door]
    @StateObject private var viewModel = CalendarViewModel()

    var body: some View {
        Text("Ahmad")
        List(doors) { door in
            VStack(alignment: .leading) {
                Text("Number is \(door.number)")
                    .font(.headline)
                
                // If 'date' is non-optional, use it directly
                Text("Date: \(door.date.formatted())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        } .onAppear {
         
            viewModel.testModelContext()
        }
    }
}


#Preview {
    DoorListView()
}
