//
//  DoorListView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//
import SwiftUI
import SwiftData

struct CalendarView2: View {
    @Query var calendars: [CalendarModel] // Automatically fetches calendars from the persistent store
    @State private var showCalendars: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if calendars.isEmpty {
                    // If no calendars exist, show a message and button to create one
                    Text("No calendars found.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showCalendars.toggle()
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 50)
                            .foregroundColor(.blue)
                    }
                } else {
                    // List all available calendars
                    List(calendars) { calendar in
                        Text(calendar.name)
                    }
                }
            }
            .sheet(isPresented: $showCalendars, onDismiss: {
                // Automatically refreshes because @Query observes changes in the database
                print("Sheet dismissed. Re-fetching calendars...")
            }) {
                CalendarView() // Replace with the actual view to create a calendar
            }
            .navigationTitle("Your Calendars")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CalendarView2()
}
