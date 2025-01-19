//
//  Notifications.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 18.01.25.
//

import Foundation
import UserNotifications

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

func createDoorNotification(door: Door) -> Void {
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
