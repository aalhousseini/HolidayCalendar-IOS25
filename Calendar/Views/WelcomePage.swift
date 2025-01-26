//
//  WelcomePage.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 05.01.25.
//

import SwiftUI

struct WelcomePage: View {
    @AppStorage("firstLaunch") var firstLaunch = true
    @State private var selectedTab = 0
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    VStack {
                        Text("WELCOME \nTO THE \nFITNESS HOLIDAY \nCALENDAR")
                            .font(.custom("Georgia", size: 36))
                            .foregroundColor(.white)
                            .padding()
                        Text("Where you can find your fitness goals and plan your fitness holiday")
                            .foregroundColor(.white)
                            .padding()
                        Button {
                            selectedTab = 1
                        } label: {
                            Circle()
                                .fill(Color.yellow)
                                .frame(width: 60, height: 60)
                                .overlay {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                        .font(.title)
                                }
                                .offset(x: 150, y: 180)
                        }
                    }
                }
                .tag(0)
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    VStack {
                        Text("Stay Active \nThis \nHoliday Season ")
                            .font(.custom("Georgia", size: 36))
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                        ZStack {
                            Capsule()
                                .fill(Color.yellow)
                                .frame(width: 120, height: 50)
                                .overlay {
                                    Text("One More Rep")
                                        .font(.custom("Georgia", size: 20))
                                        .foregroundColor(.black)
                                }
                                .rotationEffect(.degrees(-15))
                                .offset(x: -80, y: -70)
                                .padding(.bottom, 40)
                            Ellipse()
                                .fill(Color.white)
                                .frame(width: 150, height: 70)
                                .overlay(
                                    Text("Holiday Hustle")
                                        .font(.custom("Georgia", size: 20))
                                        .foregroundColor(.black)
                                )
                                .rotationEffect(.degrees(10))
                                .offset(x: 50, y: -100)
                                .padding(.bottom, 100)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 130, height: 50)
                                .overlay {
                                    Text("Workout Types")
                                        .font(.custom("Georgia", size: 20))
                                        .foregroundColor(.black)
                                }
                                .rotationEffect(.degrees(-5))
                                .offset(x: -50, y: 10)
                                .padding(.leading, 50)
                                .padding(.bottom, 50)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .frame(width: 100, height: 50)
                                .overlay {
                                    Text("Challenges")
                                        .font(.custom("Georgia", size: 20))
                                        .foregroundColor(.white)
                                }
                                .rotationEffect(.degrees(5))
                                .offset(x: -120, y: 50)
                            Capsule()
                                .fill(Color.yellow)
                                .frame(width: 120, height: 50)
                                .overlay {
                                    Text("15k Steps")
                                        .font(.custom("Georgia", size: 20))
                                        .foregroundColor(.black)
                                }
                                .rotationEffect(.degrees(-10))
                                .offset(x: 90, y: 60)
                                .padding(.leading, 50)
                                .padding(.bottom, 50)
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 130, height: 50)
                                .overlay {
                                    Text("Streak: 5 Days")
                                        .font(.custom("Georgia", size: 20))
                                        .foregroundColor(.black)
                                }
                                .rotationEffect(.degrees(15))
                                .offset(x: 10, y: 100)
                                .padding(.top, 100)
                            Circle()
                                .fill(Color.red)
                                .frame(width: 30, height: 30)
                                .offset(x: -150, y: 170)
                                .padding()
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 20)
                                .offset(x: -100, y: 190)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button {
                                        selectedTab = 2
                                    } label: {
                                        Circle()
                                            .fill(Color.yellow)
                                            .frame(width: 60, height: 60)
                                            .padding(.trailing, 20)
                                            .padding(.bottom, 20)
                                            .overlay {
                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(.black)
                                                    .font(.title)
                                            }
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
                .tag(1)
                ZStack {
                    VStack {
                        Text("READY FOR THE CHALLENGE?")
                            .font(.custom("Georgia", size: 36))
                            .foregroundColor(.white)
                            .padding()
                        Text("Create now your fitness calendar and explore your goals in your favortie holiday")
                            .foregroundColor(.white)
                            .padding()
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                selectedTab = 3
                                checkNotificationSettings()
                            } label: {
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 60, height: 60)
                                    .overlay {
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.black)
                                            .font(.title)
                                    }
                                    .padding(.trailing, 20)
                                    .padding(.bottom, 20)
                            }
                        }
                    }
                }
                .tag(2)
                ZStack{
                    VStack {
                        Image(.welcomepage)
                            .resizable()
                            .scaledToFit()
                        Text("Your journey \nbegins here. \nSign up or \nlog in \nto continue.")
                            .font(.custom("Georgia", size: 36))
                            .foregroundColor(.white)
                            .padding()
                            .foregroundColor(.white)
                        HStack {
                            Button {
                                firstLaunch = false // Update firstLaunch
                            } label: {
                                Text("Sign Up")
                                    .frame(width: 150, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                    .foregroundColor(.white)
                                    .padding()
                            }

                            Button {
                                firstLaunch = false // Update firstLaunch
                            } label: {
                                Text("Log In")
                                    .frame(width: 150, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }

                        .padding(.vertical, 50)
                    }
                }
                .tag(3)
            }
        }
            .tabViewStyle(.page)
            .ignoresSafeArea()
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .preferredColorScheme(.dark)
            
    }

            
        }


#Preview {
    WelcomePage()
}

