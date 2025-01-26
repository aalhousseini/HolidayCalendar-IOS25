//
//  File.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 05.01.25.
//

    
import Foundation



struct FirebaseAuthAPI {
        private let apiKey = "AIzaSyB-OW1revypMvU5TCfjvVUe0WH4NTdlDwo"
        private let baseURL = "https://identitytoolkit.googleapis.com/v1/accounts"
    struct User: Codable {
        let username :String
        let password :String
        let email :String
        let name :String
    }
    
    private func saveTokenToUserDefaults(idToken: String, userId: String) {
        UserDefaults.standard.set(idToken, forKey: "idToken")
        UserDefaults.standard.set(userId, forKey: "userId")
        UserDefaults.standard.synchronize()
    }


    func signUp(email: String, password: String, completion: @escaping (Result<(idToken: String, userId: String), Error>) -> Void) {
        let url = URL(string: "\(baseURL):signUp?key=\(apiKey)")!
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
        makeRequest(url: url, method: "POST", body: body, completion: completion)
    }

    func signIn(email: String, password: String, completion: @escaping (Result<(idToken: String, userId: String), Error>) -> Void) {
        let url = URL(string: "\(baseURL):signInWithPassword?key=\(apiKey)")!
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
        makeRequest(url: url, method: "POST", body: body, completion: completion)
    }
    
    private func makeRequest(url: URL, method: String, body: [String: Any], completion: @escaping (Result<(idToken: String, userId: String), Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            print("Request Body: \(body)") // Debugging the payload
            print("Request URL: \(url)")   // Debugging the URL
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response JSON: \(json)") // Debugging the response
                    if let idToken = json["idToken"] as? String,
                       let userId = json["localId"] as? String {
                        completion(.success((idToken: idToken, userId: userId)))
                        UserDefaults.standard.set(idToken, forKey: "idToken")
                        UserDefaults.standard.set(userId, forKey: "userId")
                        UserDefaults.standard.synchronize()
                    } else if let error = json["error"] as? [String: Any], let errorMsg = error["message"] as? String {
                        let customMessagError = self.createCustomErrorMessage(errorMsg)
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: customMessagError])))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                    }
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func createCustomErrorMessage(_ errorCode: String) -> String {
        switch errorCode {
        case "EMAIL_EXISTS":
            return "The email address is already in use. Please try another."
        case "INVALID_EMAIL":
            return "The email address is invalid. Please enter a valid email."
        case "WEAK_PASSWORD":
            return "Your password is too weak. It should be at least 6 characters long."
        case "EMAIL_NOT_FOUND":
            return "No account found for this email. Please sign up first."
        case "INVALID_PASSWORD":
            return "The password is incorrect. Please try again."
        case "USER_DISABLED":
            return "Your account has been disabled. Contact support for help."
        case "INVALID_LOGIN_CREDENTIALS":
            return "Your password is incorrect, please try again"
        case "MISSING_PASSWORD":
            return "Please enter a password."
        default:
            return "An error occurred. Please try again later."
        }
    }
    func sendLikeFeedback(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let idToken = UserDefaults.standard.string(forKey: "idToken"),
              let userId = UserDefaults.standard.string(forKey: "userId") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let firestoreURL = "https://firestore.googleapis.com/v1/projects/ios-auth-f7bc2/databases/(default)/documents/feedback/\(userId)"
        guard let url = URL(string: firestoreURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

        let firestoreData: [String: Any] = [
            "fields": [
                "feedbackType": ["stringValue": "like"],
                "timestamp": ["timestampValue": ISO8601DateFormatter().string(from: Date())],
                "uid": ["stringValue": userId]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: firestoreData)
            print("Firestore Like Feedback Request Body: \(firestoreData)")
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
