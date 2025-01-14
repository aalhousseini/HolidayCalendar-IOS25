//
//  WelcomeFirstTime.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 14.01.25.
//

import SwiftUI

struct WelcomeFirstTime: View {
    @State private var firsttextVisible = false
    @State private var secondtextVisible = false
    @State private var thirdtextVisible = false
    @State private var fourthtextVisible = false
    @State private var fifthtextVisible = false
    @State private var sxithtextVisible = false
    @State private var seventhtextVisible = false
    @Binding var selectedTab: Int
    var onCompletion: () -> Void
    var body: some View {
            TabView(selection: $selectedTab) {
                ZStack {
                    VStack{
                        Text("So now let's start with the fun part. ")
                            .font(.custom("HelveticaNeue", size: 54))
                            .foregroundColor(.white)
                            .opacity(firsttextVisible ? 1 : 0)
                            .animation(.easeInOut(duration: 3), value: firsttextVisible)
                            .padding()
                    }
                }
                .tag(0)
                .onAppear {
                    firsttextVisible = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            selectedTab += 1
                        }
                    }
                }
                ZStack {

                        VStack{
                            Text("We need to make sure that we have a good schedule. ")
                                .font(.custom("HelveticaNeue", size: 54))
                                .foregroundColor(.white)
                                .opacity(secondtextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 3), value: secondtextVisible)
                                .padding()
                        }
                    }
                    .tag(1)
                    .onAppear {
                        secondtextVisible = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                selectedTab += 1
                            }
                        }
                    }

                    ZStack {

                        VStack{
                            Text("You can specify how long your calendar should be. ")
                                .font(.custom("HelveticaNeue", size: 54))
                                .foregroundColor(.white)
                                .opacity(thirdtextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 3), value: thirdtextVisible)
                                .padding()

                        }
                    }
                    .tag(2)
                    .onAppear {
                        thirdtextVisible = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                selectedTab += 1
                            }
                        }
                    }
                    ZStack {
                        VStack{
                            Text("Each day you can open one door. Each door has a different challenge.  ")
                                .font(.custom("HelveticaNeue", size: 54))
                                .foregroundColor(.white)
                                .opacity(fourthtextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 3), value: fourthtextVisible)
                                .padding()
                        }
                    }
                    .tag(3)
                    .onAppear {
                        fourthtextVisible = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                selectedTab += 1
                            }
                        }
                    }
                    ZStack {
                        VStack{
                            Text("When you complete your challenge you can attach a photo , a quote , or you can write a note to your door.  ")
                                .font(.custom("HelveticaNeue", size: 54))
                                .foregroundColor(.white)
                                .opacity(fifthtextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 3), value: fifthtextVisible)
                                .padding()

                        }
                    }
                    .tag(4)
                    .onAppear {
                        fifthtextVisible = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                            withAnimation {
                                selectedTab += 1
                            }
                        }
                    }
                    ZStack {
                        VStack{
                            Text("When you are done with your challenge you can share it with your friends and family.")
                                .font(.custom("HelveticaNeue", size: 54))
                                .foregroundColor(.white)
                                .opacity(sxithtextVisible ? 1 : 0)
                                .animation(.easeInOut(duration: 3), value: sxithtextVisible)
                                .padding()

                            Spacer()
                            HStack {
                                Text("Interesting ? Lets' do it")
                                    .font(.custom("HelveticaNeue", size: 34))
                                    .opacity(seventhtextVisible ? 1 : 0)
                                    .animation(.easeInOut(duration: 3), value: seventhtextVisible)
                                    .padding()
                                Spacer()
                                if seventhtextVisible {
                                    Button (action: {
                                        selectedTab = 6
                                    }){
                                        Circle()
                                            .fill(Color.yellow)
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(.black)
                                                    .font(.title)
                                            )
                                            .padding(.trailing, 20) // Add padding from the edge
                                            .padding(.bottom, 20)   // Add padding from the bottom
                                    }
                                }
                            }
                        }
                    }
                    .tag(5)
                    .onAppear {
                        sxithtextVisible = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                seventhtextVisible = true
                                onCompletion()

                            }
                        }

                    }

            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .preferredColorScheme(.dark)
            /*.navigationTitle(selectedTab == 7 ? "Calendar" : "Create Calendar")*/ // Title changes dynamically
            .navigationBarTitleDisplayMode(.inline)
        }
    }


#Preview {
    @Previewable @State var selectedTab = 0
    WelcomeFirstTime(selectedTab: $selectedTab, onCompletion: {})
}
