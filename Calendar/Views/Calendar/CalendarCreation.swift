////
////  CalendarVreation.swift
////  Calendar
////
////  Created by Al Housseini, Ahmad on 16.01.25.
////
//
//import SwiftUI
//
//struct CalendarCreation: View {
//    @State private var calendarName: String = ""
//    @State private var numberOfDoors: Int = 1
//    @StateObject private var viewModel = CalendarViewModel()
//    @AppStorage("firstCalendarCreated") private var firstCalendarCreated: Bool = false
//    var body: some View {
//        ZStack {
//            Color("BackgroundColor")
//                .edgesIgnoringSafeArea(.all)
//            VStack(spacing: 20) {
//                VStack {
//                    Text("Calendar Name")
//                        .font(.custom("HelveticaNeue", size: 34))
//                        .foregroundColor(.primary)
//
//                    TextField("Enter Calendar Name", text: $calendarName)
//                        .padding(12)
//                        .foregroundColor(.white)
//                        .font(.system(size: 16, weight: .regular))
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(Color.black)
//                        )
//                        .frame(width: 280, height: 50)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
//                                .shadow(color: Color.blue.opacity(0.6), radius: 10)
//                        )
//                        .accentColor(.blue)
//                        .padding(.horizontal, 20)
//
//                    Spacer().frame(height: 50)
//
//                    VStack {
//                        Text("Number of Doors")
//                            .font(.custom("HelveticaNeue", size: 34))
//                            .foregroundColor(.primary)
//
//                        HStack {
//                            Button(action: {
//                                if numberOfDoors > 1 {
//                                    numberOfDoors -= 1
//                                }
//                            }) {
//                                Image(systemName: "minus")
//                                    .padding()
//                                    .frame(width: 50, height: 50)
//                                    .background(Color.blue)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(100)
//                            }
//
//                            Spacer()
//
//                            Text("\(numberOfDoors) \(numberOfDoors == 1 ? "door" : "doors")")
//                                .padding(40)
//
//                            Spacer()
//
//                            Button(action: {
//                                numberOfDoors += 1
//                            }) {
//                                Image(systemName: "plus")
//                                    .padding()
//                                    .frame(width: 50, height: 50)
//                                    .background(Color.blue)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(100)
//                            }
//                        }
//                    }
//
//                    Spacer().frame(height: 50)
//
//                    Button(action: {
//                        Task {
//                            let doors = viewModel.createDoors(
//                                totalDoors: numberOfDoors,
//                                startDate: Date()
//                            )
//
//                            await MainActor.run {
//                                viewModel.createCalendar(
//                                    name: calendarName,
//                                    doors: doors,
//                                    startDate: Date(),
//                                    challenges: []
//                                )
//                                firstCalendarCreated = true
//                                CalendarView2()
//                            }
//                        }
//                    }) {
//                        Text("Create Calendar")
//                            .font(.custom("HelveticaNeue", size: 34))
//                            .frame(width: 280, height: 70)
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(Color.blue)
//                            )
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                }
//            }
//        } .preferredColorScheme(.dark)
//    }
//}
//
//#Preview {
//    CalendarCreation()
//}
