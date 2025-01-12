//
//  SwiftDataSaver.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 09.01.25.
//

import Foundation
import SwiftData


struct SwiftDataSaver {
    func putUser(userId: String, data: [String: Any], modelContext: ModelContext) {
            // Extract fields from data dictionary
            let username = (data["username"] as? String) ?? ""
            let password = (data["password"] as? String) ?? ""
            let email = (data["email"] as? String) ?? ""
            let name = (data["name"] as? String) ?? ""

            // Create a FetchDescriptor to find the existing user
            let fetchDescriptor = FetchDescriptor<User>(
                predicate: #Predicate { $0.userId == userId }
            )

            // Try to fetch the existing user
            if let existing = try? modelContext.fetch(fetchDescriptor).first {
                // Update existing user
                existing.username = username
                existing.name = name
                existing.email = email
                existing.password = password
            } else {
                // Create a new user
                let newUser = User(userId: userId, username: username,password: password, email: email, name: name)
                modelContext.insert(newUser)
            }

            // Save the context
            do {
                try modelContext.save()
                print("User saved successfully!")
            } catch {
                print("Failed to save user: \(error.localizedDescription)")
            }
        }
    
    func fetchUserbyId(userId: String, modelContext: ModelContext) -> User? {
        let fetchDescriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.userId == userId }
        )
        do {
            return try modelContext.fetch(fetchDescriptor).first
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllUsers(modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<User>()
        do {
            let users = try modelContext.fetch(fetchDescriptor)
            print("Stored Users: \(users)")
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
        }
    }


    }



