//
//  Profile.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 09.01.25.
// This UI was inspired by https://dribbble.com/shots/19230852-All-in-One-Platform

import SwiftUI
import SwiftData

struct Home: View {
    @AppStorage("nameStorage") var nameStorage : String = ""
   // @AppStorage("timeleftToOpen") private var timeleftToOpen: String = ""
    @AppStorage("isLoggedIn")  var isLoggedIn = false
    @AppStorage("firstLaunch")  var firstLaunch = false
    @State private var timeLeftToOpen: String = "Calculating..."
    @State private var timer: Timer? = nil
    @Query private var calendars: [CalendarModel]
    var body: some View {
        NavigationView {
            VStack {
                VStack (alignment: .leading) {
                    Text("Welcome back")
                        .font(.custom("Georgia", size: 35))
                    Text("\(nameStorage)")
                        .font(.custom("Georgia", size: 35))
                }
                .padding()
                HStack {
                    Text("Don't forget")
                        .font(.custom("Georgia", size: 15))
                    Spacer()
                    NavigationLink(destination: CalendarListView()) {
                        Text("Go to calendar")
                            .font(.custom("Georgia", size: 15))
                        Image(systemName: "arrow.right")
                    }
                }
                .padding()
                ZStack {
                    ForEach((0..<3).reversed(), id: \.self) { index in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(index == 0 ? .black : .gray) // Keep all cards black
                            .frame(width: 300, height: 120) // Fixed size for cards
                            .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 5, y: 5) // Add shadow for stacking
                            .offset(x: CGFloat(index * 10), y: CGFloat(index * 10)) // Slight offset for stacking
                    }
                    Text("Time left to open: \(timeLeftToOpen)")
                        .font(.custom("Georgia", size: 15))
                        .foregroundColor(.white)
                }
                .onAppear {
                                 calculateNextDoorUnlock()
                             }
                .padding()
                Spacer()
                    .frame(height: 50)
                ActivityStatsView(caloriesBurned: 724, steps: 4087, distance: 2.11, activityTime: "12:06")
                Spacer()
                    .frame(height: 50)
                Button {
                    isLoggedIn = false
                    UserDefaults.standard.set(true, forKey: "firstLaunch")
                } label: {
                    Text("Logout")
                        .font(.custom("Georgia", size: 22))
                        .foregroundColor(.red)
                }
                .padding()
        
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(Date(), style: .date)
                        .font(.custom("Georgia", size: 22))
                        .foregroundColor(.primary)
                }
                ToolbarItem {
                    Button {
                        print("bell")
                    } label: {
                        Image(systemName: "bell")
                            .badge(1)
                    }
                }
            }
        }
    }
    
    private func calculateNextDoorUnlock() {
        timer?.invalidate() // Stop any previous timer

        if let nextDoor = calendars.nextDoorToUnlock {
            startCountdown(for: nextDoor)
        } else {
            timeLeftToOpen = "All doors are unlocked!"
        }
    }

    // Start a countdown for the next door
    private func startCountdown(for door: DoorModel) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let now = Date()
            if door.unlockDate > now {
                let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: door.unlockDate)
                timeLeftToOpen = "\(components.hour ?? 0)h \(components.minute ?? 0)m \(components.second ?? 0)s"
            } else {
                timeLeftToOpen = "Unlocked"
                timer?.invalidate()
            }
        }
    }
}

#Preview {
    Home()
}
