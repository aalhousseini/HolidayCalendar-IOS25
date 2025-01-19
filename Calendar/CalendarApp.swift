//
//  CalendarApp.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//

import SwiftUI
import SwiftData

@main
struct CalendarApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            CalendarModel.self,
            DoorModel.self,
          
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    checkNotificationSettings()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
 
