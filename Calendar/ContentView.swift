//
//  ContentView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
    
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
        .modelContainer(for: Item.self, inMemory: true)
}
