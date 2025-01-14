//
//  File.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 12.01.25.
//

import Foundation

struct ChallengeLoader {
    static func loadChallenges() -> [Challenge] {
        guard let url = Bundle.main.url(forResource: "challenges", withExtension: "json") else {
            fatalError("Could not find challenges.json")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let challenges = try JSONDecoder().decode([Challenge].self, from: data)
            return challenges
        } catch {
            print("Error decoding challenges: \(error)")
            return []
        }
    }
    
    static func loadRandomChallenge() -> Challenge? {
        let challenges = loadChallenges()
        return challenges.randomElement()
    }
}
