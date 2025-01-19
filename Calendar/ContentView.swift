//
//  ContentView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("isLoggedIn")  var isLoggedIn = false

    var body: some View {
        if(isLoggedIn) {
            Mainpage()
        } else {
            LogIn()
        }
    }
}

#Preview {
    ContentView()
}
