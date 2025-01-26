//
//  ContentView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("firstLaunch") private var firstLaunch = true

    var body: some View {
        if firstLaunch {
            WelcomePage()
        } else if isLoggedIn {
            Mainpage()
        } else {
            LogIn()
        }
    }
}

#Preview {
    ContentView()
}
