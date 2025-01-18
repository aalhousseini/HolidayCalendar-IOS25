//
//  ActivityStatsView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 17.01.25.
//

import SwiftUI

struct ActivityStatsView: View {
    let caloriesBurned: Int
        let steps: Int
        let distance: Double // Distance in km
        let activityTime: String // Time as a string (e.g., "45:00")

    var body: some View {
        VStack(spacing: 16) {
            // Calories burned
            HStack {
                Text("\(caloriesBurned) kcal")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("your activity")
                    .font(.custom("", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(height: 130)
            .background(Color.blue)
            .cornerRadius(12)
            .foregroundColor(.white)

            // Additional stats (e.g., steps, distance, activity time)
            HStack(spacing: 16) {
                StatBox(title: "\(steps)", subtitle: "steps")
                StatBox(title: String(format: "%.2f km", distance), subtitle: "distance")
                StatBox(title: activityTime, subtitle: "activity time")
            }
        }
        .padding(.horizontal)
    }
}
struct StatBox: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height:80)
        .padding()
        .background(.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    ActivityStatsView(caloriesBurned: 765, steps: 4333, distance: 2, activityTime: "9")
}

//Spacer().frame(height: 40)
//// Mock data
//ActivityStatsView(
//                  caloriesBurned: 724,
//                  steps: 4087,
//                  distance: 2.11,
//                  activityTime: "12:06"
//              )
//
//Spacer().frame(height: 50)
