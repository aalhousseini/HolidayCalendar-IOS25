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
    @Published var challenges: [Challenge] = []
    
    
    init() {
        testModelContext()
    }
    
    func testModelContext() {
        do {
            let testFetch = try modelContext.fetch(FetchDescriptor<Calendars>())
            print("Test fetch result: \(testFetch.count)")
        } catch {
            print("Error testing modelContext: \(error)")
        }
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
    
//    func createCalendar (name:String, doors:[Door], startDate: Date,challenges: [Challenge]){
//        let newCalendar = Calendars(name:name, startDate:startDate, doors: doors)
//        modelContext.insert(newCalendar)
//        do {
//            try modelContext.save()
//            print("Calendar successfully saved.")
//        } catch {
//            print("Error saving doors: \(error)")
//        }
//    }
    func createCalendar(name: String, doors: [Door], startDate: Date, challenges: [Challenge]) {
        let newCalendar = Calendars(name: name, startDate: startDate, doors: doors)
        modelContext.insert(newCalendar)
        do {
            try modelContext.save()
            print("Calendar successfully saved with ID: \(newCalendar.id)")
        } catch {
            print("Error saving calendar: \(error)")
        }
    }
    
    func createDoors(totalDoors: Int, startDate: Date, challenges: [Challenge]) -> [Door] {
        var shuffledChallenges = challenges.shuffled()
        doors = (0..<totalDoors).map { index in
            let creationDate = Calendar.current.date(byAdding: .day, value: index, to: startDate) ?? Date()
            let challenge = shuffledChallenges.isEmpty ? nil : shuffledChallenges.removeFirst()
            let door = Door(
                number: index + 1,
                date: creationDate,
                isOpened: false,
                challenge: challenge
            )
            modelContext.insert(door)
            return door
        }
        do {
            try modelContext.save()
            print("Doors successfully saved.")
        } catch {
            print("Error saving doors: \(error)")
        }
        return doors
    }


//    
//    func createDoors(totalDoors: Int, startDate: Date, challenges: [Challenge]) -> [Door] {
//        doors = (0..<totalDoors).map { index in
//            let creationDate = calendar.date(byAdding: .day, value: index, to: startDate) ?? Date()
//            let door = Door(
//                number: index + 1,
//                date: creationDate,
//                isOpened: false,
//                challenge: challenges.randomElement() // Assign random challenge
//            )
//            modelContext.insert(door)
//            print("Created door \(door.number) with date \(door.date)")
//            return door
//        }
//        do {
//            try modelContext.save()
//            print("Doors successfully saved.")
//        } catch {
//            print("Error saving doors: \(error)")
//        }
//        return doors
//    }
    
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
    func timeUntilNextDoor() -> String? {
         guard let nextDoor = doors.first(where: { !$0.isOpened }) else {
             return nil // No more doors to open
         }

         let now = Date()
         let remainingTime = nextDoor.date.timeIntervalSince(now)
         
         guard remainingTime > 0 else {
             return "Door can be opened now!"
         }

         let hours = Int(remainingTime) / 3600
         let minutes = (Int(remainingTime) % 3600) / 60
         let seconds = Int(remainingTime) % 60
        
        print("From  Method :")

         return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
     }
    
    /// Finds the next door that can be opened.
    private func nextDoorToOpen() -> Door? {
        return doors.first { !$0.isOpened } // Finds the first unopened door
    }
    
    func updateCalendarById(_ id: UUID, newName: String, newTotalDoors: Int, challenges: [Challenge]) {
        guard let calendar = calendars.first(where: { $0.id == id }) else {
            print("Calendar with id \(id) not found.")
            return
        }
        
        calendar.name = newName
        
        let currentDoors = calendar.doors.count
        if newTotalDoors > currentDoors {
            let extraDoors = (currentDoors..<newTotalDoors).map { index in
                let creationDate = Calendar.current.date(byAdding: .day, value: index, to: Date()) ?? Date()
                return Door(
                    number: index + 1,
                    date: creationDate,
                    isOpened: false,
                    challenge: challenges.randomElement()
                )
            }
            calendar.doors.append(contentsOf: extraDoors)
        } else if newTotalDoors < currentDoors {
            calendar.doors.removeLast(currentDoors - newTotalDoors)
        }
        
        do {
            try modelContext.save()
            print("Calendar updated successfully.")
        } catch {
            print("Failed to update calendar: \(error)")
        }
    }
}
