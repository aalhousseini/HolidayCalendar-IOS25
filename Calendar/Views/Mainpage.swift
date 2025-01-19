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
               
               CalendarListView()
                   .tabItem {
                       Image(systemName: "calendar")
                       Text("Calendar")
                   }
               
               CalendarCreateView()
                   .tabItem {
                       Image(systemName: "calendar.badge.plus")
                       Text("Add")
                   }
           }
           .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    Mainpage()
}
