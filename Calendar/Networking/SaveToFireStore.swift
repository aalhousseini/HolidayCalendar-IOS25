//
//  SaveToFireStore.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 08.01.25.
//

import Foundation


struct SaveToFireStore {
//    struct CalendarModelExtra: Codable {
//        var id: String // Ensure this is a `String`
//        var name: String
//        var startDate: Date
//        var doors: [Door]
//    }

    
    
    private let idToken = "AIzaSyB-OW1revypMvU5TCfjvVUe0WH4NTdlDwo"
    //private let  firestoreURL = "https://firestore.googleapis.com/v1/projects/ios-auth-f7bc2/databases/(default)/documents/users/\(userId)"
    
    func saveUser(uid: String, username: String, name: String, email: String, password: String, idToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
            // Firestore endpoint
            let firestoreURL  = "https://firestore.googleapis.com/v1/projects/ios-auth-f7bc2/databases/(default)/documents/users/\(uid)"
            
            guard let url = URL(string: firestoreURL) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PATCH" // Use PATCH to upsert (create or update)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

            let firestoreData: [String: Any] = [
                "fields": [
                    "username": ["stringValue": username],
                    "name": ["stringValue": name],
                    "email": ["stringValue": email],
                    "password":["stringValue": password]
                ]
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: firestoreData)
                print("Firestore Request Body: \(firestoreData)")
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network Error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("No HTTP Response")
                    completion(.failure(NSError(domain: "No HTTP Response", code: 0, userInfo: nil)))
                    return
                }

                print("Response Code: \(httpResponse.statusCode)")

                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }

                if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                    completion(.success(()))
                } else {
                    completion(.failure(NSError(domain: "Firestore Error", code: httpResponse.statusCode, userInfo: nil)))
                }
            }.resume()
        }
    func saveCalendar(
        id: String,
        name: String,
        startDate: Date,
        doors: [[String: Any]], // Represent doors as dictionaries
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Firestore endpoint
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/ios-auth-f7bc2/databases/(default)/documents/calendars/\(id)"
        
        guard let url = URL(string: firestoreURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH" // Use PATCH to upsert (create or update)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer <ID_TOKEN>", forHTTPHeaderField: "Authorization") // Replace <ID_TOKEN> dynamically

        let firestoreData: [String: Any] = [
            "fields": [
                "name": ["stringValue": name],
                "startDate": ["timestampValue": ISO8601DateFormatter().string(from: startDate)],
                "doors": ["arrayValue": ["values": doors.map { ["mapValue": $0] }]]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: firestoreData)
            print("Firestore Request Body: \(firestoreData)")
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTP Response")
                completion(.failure(NSError(domain: "No HTTP Response", code: 0, userInfo: nil)))
                return
            }

            print("Response Code: \(httpResponse.statusCode)")

            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseBody)")
            }

            if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "Firestore Error", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }

    }
   
