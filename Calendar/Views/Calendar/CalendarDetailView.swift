//
//  CalendarDetailView.swift
//  Calendar
//
//  Created by Hanno Wiesen on 18.01.25.
//
import SwiftUI

struct CalendarDetailView: View {
    var calendar: CalendarModel
    
    var body: some View {
        NavigationView {
            List {
                Section("Allgemein") {
                    LabeledContent("Name", value: calendar.name)
                }
                
                Section("Doors") {
                    ForEach(self.calendar.doors) { door in
                        NavigationLink {
                            DoorDetailView(door: door)
                        } label: {
                            HStack {
                                Text(door.isLocked ? "🔒" : "")
                                Text(door.isCompleted ? "✅" : "")
                                Text("Door \(door.number + 1)")
                                Spacer()
                            }
                        }
                    }
                }
                  
            }
            .navigationTitle("\(self.calendar.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
