//
//  Profile.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 09.01.25.
// This UI was inspired by https://dribbble.com/shots/19230852-All-in-One-Platform

import SwiftUI
import PhotosUI

struct Home: View {
    @AppStorage("nameStorage") var nameStorage : String = ""
    @AppStorage("isLoggedIn")  var isLoggedIn = false
    let date = dateLocal()
    
    var body: some View {
        
        NavigationView {
            VStack {
                //Welcome $name of the user
                VStack (alignment: .leading) {
                    
                        Text("Welcome back")
                            .font(.custom("Georgia", size: 35))
                            
                        Text("\(nameStorage)")
                            .font(.custom("Georgia", size: 35))
                    
                   
                    
                    // calendar countdown until next door can be opened
                    
                    
                }
                .padding()
                
                HStack {
                    Text("Don't forget")
                        .font(.custom("Georgia", size: 15))
                    
                    Spacer()
                    
                    NavigationLink(destination: CalendarView()) {
                        Text("Go to calendar")
                        .font(.custom("Georgia", size: 15))
                        Image(systemName: "arrow.right")
                    }
//                    Button (action : {
//                        CalendarView()
//                    }) {
//                        Text("Go to calendar")
//                        .font(.custom("Georgia", size: 15))
//                        Image(systemName: "arrow.right")
//                    }
                } .padding()
                

                ZStack {
                    ForEach((0..<3).reversed(), id: \.self) { index in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(index == 0 ? .black : .gray) // Keep all cards black
                            .frame(width: 300, height: 120) // Fixed size for cards
                            .shadow(color: Color.gray.opacity(0.5), radius: 8, x: 5, y: 5) // Add shadow for stacking
                            .offset(x: CGFloat(index * 10), y: CGFloat(index * 10)) // Slight offset for stacking
                    }
                    Text("Time left to \nopen is")
                        .font(.custom("Georgia", size: 15))
                        .foregroundColor(.white)
                }
                .padding()
                
                Button(action: {
                    isLoggedIn = false
                }) {
                    Text("Logout")
                        .font(.custom("Georgia", size: 22))
                        .foregroundColor(.red)
                } .padding()
                
                  
                    
                
            }
         
            
//            .navigationTitle(date.getDate())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(date.getDate())
                        .font(.custom("Georgia", size: 22))
                        .foregroundColor(.primary)
                }
                 ToolbarItem {
                    Button(action: {
                      print("bell")
                    }) {
                        Image(systemName: "bell")
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: -10, y: 1)
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    Home()
}
