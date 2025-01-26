//
//  Notifications.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 18.01.25.
//

import Foundation
import UserNotifications
//
//func exportCalendar(calendar: CalendarModel) -> Void {
//    do {
//        var calendarToEncode = CalendarCodable()
//        calendarToEncode.name = calendar.name
//        calendarToEncode.startDate = calendar.startDate
//        calendarToEncode.doors = []
//        
//        for door in calendar.doors {
//            var doorToEncode = DoorCodable()
//            doorToEncode.number = door.number
//            doorToEncode.unlockDate = door.unlockDate
//            doorToEncode.challenge = door.challenge
//            doorToEncode.isCompleted = false
//            
//            calendarToEncode.doors!.append(doorToEncode)
//        }
//        
//        let jsonEncoder = JSONEncoder()
//        let jsonData = try jsonEncoder.encode(calendarToEncode)
//    
//        let docFolder = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//        let destinationUrl = docFolder.appendingPathComponent("\(calendar.id)_export.json")
//
//        try jsonData.write(to: destinationUrl)
//    } catch {
//        fatalError(error.localizedDescription)
//    }
//}
func exportCalendar(calendar: CalendarModel) -> Void {
    do {
        var calendarToEncode = CalendarCodable()
        calendarToEncode.name = calendar.name
        calendarToEncode.startDate = calendar.startDate
        calendarToEncode.doors = []

        for door in calendar.doors {
            var doorToEncode = DoorCodable()
            doorToEncode.number = door.number
            doorToEncode.unlockDate = door.unlockDate
            doorToEncode.challenge = door.challenge
            doorToEncode.isCompleted = door.isCompleted
            
            // Encode image data as Base64 string
            if let imageData = door.image {
                doorToEncode.image = imageData.base64EncodedString()
            }
            
            if let quote = door.quote {
                doorToEncode.quote = quote
            }

            calendarToEncode.doors!.append(doorToEncode)
        }

        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(calendarToEncode)

        let docFolder = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destinationUrl = docFolder.appendingPathComponent("\(calendar.name)_\(calendar.id)_export.json")

        try jsonData.write(to: destinationUrl)

        print("Calendar exported to \(destinationUrl)")
    } catch {
        print("Error exporting calendar: \(error.localizedDescription)")
    }
}

func importCalendar(url: URL) -> CalendarModel? {
    do {
        let data = try Data(contentsOf: url)
        let object = try JSONDecoder().decode(CalendarCodable.self, from: data)
        
        guard let newCalendarName = object.name, let newCalendarStartDate = object.startDate, let newCalendarDoors = object.doors else {
            print("Invalid calendar data.")
            return nil
        }

        let newCalendarModel = CalendarModel(name: newCalendarName, startDate: newCalendarStartDate)
        newCalendarModel.doors = []
        newCalendarModel.isImported = true

        for door in newCalendarDoors {
            guard let newNumber = door.number, let newUnlockDate = door.unlockDate, let newChallenge = door.challenge else {
                print("Invalid door data.")
                return nil
            }

            let newDoorModel = DoorModel(number: newNumber, unlockDate: newUnlockDate, challenge: newChallenge)
            newDoorModel.calendar = newCalendarModel
            newDoorModel.isImported = true

            // Decode Base64 string back into Data
            if let imageBase64 = door.image, let imageData = Data(base64Encoded: imageBase64) {
                newDoorModel.image = imageData
            }
            if let quote = door.quote {
                newDoorModel.quote = quote
            }

            newCalendarModel.doors.append(newDoorModel)
        }

        print("Calendar successfully imported: \(newCalendarModel.name)")
        return newCalendarModel
    } catch {
        print("Error importing calendar: \(error.localizedDescription)")
    }
    return nil
}



func requestNotificationPermission() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        DispatchQueue.main.async {
            if let error = error {
                // Handle the error here.
                print("Error requesting notification authorization: \(error)")
                return
            }
            
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
}

func checkNotificationSettings() {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
        DispatchQueue.main.async {
            switch settings.authorizationStatus {
            case .notDetermined:
                // Permission has not been requested yet.
                requestNotificationPermission()
            case .denied:
                // Permission was previously denied.
                print("Notifications permission was denied.")
            case .authorized, .provisional, .ephemeral:
                // Permission was granted or allowed provisionally.
                print("Notifications permission already granted.")
            @unknown default:
                print("Unknown notification settings status.")
            }
        }
    }
}

func createDoorNotification(door: DoorModel) -> Void {
    let content = UNMutableNotificationContent()
    content.title = "New Door"
    content.body = "You can open a new Door in \(door.calendar?.name ?? "a calendar")"
    content.sound = .default
    
    let triggerDate = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: door.unlockDate) ?? door.unlockDate
    let triggerDateComponents = Calendar.current.dateComponents([.hour, .minute, .day, .month], from:  triggerDate)

    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        DispatchQueue.main.async {
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for \(triggerDate).")
            }
        }
    }
}
