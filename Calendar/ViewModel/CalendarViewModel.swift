//
//  CalendarViewModel.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 10.01.25.
//

import SwiftUI
import SwiftData


class CalendarViewModel: ObservableObject {
    @Published var doors: [Door] = []
    @Environment(\.modelContext) private var modelContext
    @Published var calendars: [Calendars] = []
    private let calendar = Calendar.current

    init() {
        fetchCalendars()
    }
    
    func fetchCalendars() {
           let fetchDescriptor = FetchDescriptor<Calendars>(sortBy: [SortDescriptor(\.startDate)])
           do {
               calendars = try modelContext.fetch(fetchDescriptor)
               print("Fetched calendars: \(calendars.count)")
           } catch {
               print("Failed to fetch calendars: \(error)")
           }
       }
    
    func createCalendar (name:String, totalDoors:Int, startDate: Date,challenges: [Challenge]){
        let newDoors = (0..<totalDoors).map {index in
            let creationDate = calendar.date(byAdding: .day, value: index, to: startDate) ?? Date()
            return  Door(number: index + 1,
                            date: creationDate,
                            isOpened: false,
                            challenge: challenges.randomElement())
            
        }
        let newCalendar = Calendars(name:name, startDate:startDate, doors: newDoors)
        modelContext.insert(newCalendar)
        do {
            try modelContext.save()
            print("Doors successfully saved.")
        } catch {
            print("Error saving doors: \(error)")
        }
    }

    func createDoors(totalDoors: Int, startDate: Date, challenges: [Challenge]) {
        doors = (0..<totalDoors).map { index in
            let creationDate = calendar.date(byAdding: .day, value: index, to: startDate) ?? Date()
            let door = Door(
                number: index + 1,
                date: creationDate,
                isOpened: false,
                challenge: challenges.randomElement() // Assign random challenge
            )
            modelContext.insert(door)
            print("Created door \(door.number) with date \(door.date)")
            return door
        }
        do {
            try modelContext.save()
            print("Doors successfully saved.")
        } catch {
            print("Error saving doors: \(error)")
        }
    }

    func fetchDoors() {
        let fetchDescriptor = FetchDescriptor<Door>(sortBy: [SortDescriptor(\.number)])
        do {
            doors = try modelContext.fetch(fetchDescriptor) // Fetch and update the doors array
            print("Fetched doors: \(doors.count)")
        } catch {
            print("Failed to fetch doors: \(error)")
        }
    }

//    func selectCalendar(_ calendar: Calendar) {
//        doors = calendars. // Update doors for the selected calendar
//    }

    /// Determines whether a door can be opened.
    func canOpen(door: Door) -> Bool {
        guard let firstUnavailableDoor = nextDoorToOpen() else { return false }

        // A door can only be opened if it's the next sequential door and today >= its date.
        let today = calendar.startOfDay(for: Date())
        return door.id == firstUnavailableDoor.id && today >= calendar.startOfDay(for: door.date)
    }

    /// Opens a door if allowed.
    func openDoor(_ door: Door) {
        guard canOpen(door: door) else {
            print("Door \(door.number) cannot be opened yet.")
            return
        }

        if let index = doors.firstIndex(where: { $0.id == door.id }) {
            doors[index].isOpened = true
        }
        do {
            try modelContext.save()
            print("Door \(door.number) opened.")
        } catch {
            print("Error saving doors: \(error)")
        }
    }

    /// Finds the next door that can be opened.
    private func nextDoorToOpen() -> Door? {
        return doors.first { !$0.isOpened } // Finds the first unopened door
    }
}
