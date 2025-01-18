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

func scheduleTestNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Test Notification"
    content.body = "This is a test notification."
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        DispatchQueue.main.async {
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled.")
            }
        }
    }
}
