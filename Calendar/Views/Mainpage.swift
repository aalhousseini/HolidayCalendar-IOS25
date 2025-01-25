//
//  Mainpage.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 08.01.25.
//

import SwiftUI

struct Mainpage: View {
    @AppStorage("firstLaunch")  var firstLaunch = false
    @State private var selectedTab: Int = 0
    
    var body: some View {
//        if firstLaunch {
//            WelcomePage()
//        } else {
        TabView(selection: $selectedTab) {
               Home()
                   .tabItem {
                       Image(systemName: "square.grid.2x2")
                       Text("Home")
                   }
                   .tag(0)
               
               CalendarListView()
                   .tabItem {
                       Image(systemName: "calendar")
                       Text("Calendar")
                   }
                   .tag(1)
               CalendarCreateView(selectedTab: $selectedTab)
                   .tabItem {
                       Image(systemName: "calendar.badge.plus")
                       Text("Add")
                   }
                   .tag(2)
           }
           .preferredColorScheme(.dark)
        }
    }
//}

#Preview {
    Mainpage()
}
