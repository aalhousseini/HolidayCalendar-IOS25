//
//  DoorListView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//
import SwiftUI
import SwiftData

struct CalendarListView: View {
    @Query var calendars: [CalendarModel]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack {
                if calendars.isEmpty {
                    Text("No calendars found.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                } else {
                    List(calendars) { calendar in
                        NavigationLink {
                            Text("Calendar Detail View goes here...")
                        } label: {
                            Text(calendar.name)
                                .swipeActions {
                                    Button("Löschen", role: .destructive) {
                                        modelContext.delete(calendar)
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Your Calendars")
        }
    }
}

#Preview {
    CalendarListView()
}
