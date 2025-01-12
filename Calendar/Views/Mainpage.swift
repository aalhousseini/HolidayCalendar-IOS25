//
//  Mainpage.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 08.01.25.
//

import SwiftUI

struct Mainpage: View {
    @AppStorage("firstLaunch")  var firstLaunch = false
    var body: some View {
        if firstLaunch {
            WelcomePage()
        } else {
           TabView {
               Home()
                   .tabItem {
                       Image(systemName: "square.grid.2x2")
                       Text("Home")
                   }
               
               CalendarView()
                   .tabItem {
                       Image(systemName: "calendar")
                       Text("Calendar")
                   }
               
               Text("Add")
                   .tabItem {
                       Image(systemName: "calendar.badge.plus")
                       Text("Add")
                   }
               
               Text("Messages")
                   .tabItem {
                       Image(systemName: "bubble.left.and.bubble.right")
                       Text("Messages")
                   }
               
               Profile()
                   .tabItem {
                       Image(systemName: "person.circle")
                       Text("Profile")
                   }
           }.preferredColorScheme(.dark)
        }
    }
   }

#Preview {
    Mainpage()
}
