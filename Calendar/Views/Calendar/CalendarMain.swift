//
//  CalendarMain.swift
//  Calendar_1
//
//  Created by Al Housseini, Ahmad on 26.01.25.
//

import SwiftUI

struct CalendarMain: View {
    @State private var selectedTab: Int = 0
    @AppStorage("firstCalendar") private var firstCalendar = true
    var body: some View {
       
            if firstCalendar {
                WelcomeFirstTime(selectedTab: $selectedTab) {
                    // Move to CalendarCreateView after completion
                    firstCalendar = false
                }
            } else {
                CalendarCreateView(selectedTab: $selectedTab)
            }
    }
}

#Preview {
    CalendarMain()
}
