//
//  CalendarView.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 09.01.25.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
  @State private var firsttextVisible = false
  @State private var secondtextVisible = false
  @State private var thirdtextVisible = false
  @State private var fourthtextVisible = false
  @State private var fifthtextVisible = false
  @State private var sxithtextVisible = false
  @State private var seventhtextVisible = false
  @State private var firstTime = false
  @State private var selectedTab = 0
  @State var calendarName: String = ""
  @State private var selectedCalendar: Calendar? = nil
  @State private var numberOfDoors: Int = 1
  @StateObject private var viewModel = CalendarViewModel()
  @Environment(\.modelContext) private var modelContext
  @Query var doors: [Door]
  let challenges: [Challenge] = []

  var body: some View {
    TabView(selection: $selectedTab) {
      //                        .sheet(isPresented: $isSheetPresented) {
      //                                    if let door = selectedDoor {
      //                                        DoorDetailView(door: door)
      //                                    }
      //                                }
//
//                  ZStack {
//                      VStack{
//                          Text("So now let's start with the fun part. ")
//                              .font(.custom("HelveticaNeue", size: 54))
//                              .foregroundColor(Color("TextColor"))
//                              .opacity(firsttextVisible ? 1 : 0)
//                              .animation(.easeInOut(duration: 3), value: firsttextVisible)
//                              .padding()
//                      }
//                  }
//                  .tag(0)
//                  .onAppear {
//                      firsttextVisible = true
//                      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                          withAnimation {
//                              selectedTab = 1
//                          }
//                      }
//                  }
//                  ZStack {
//      
//                      VStack{
//                          Text("We need to make sure that we have a good schedule. ")
//                              .font(.custom("HelveticaNeue", size: 54))
//                              .foregroundColor(.white)
//                              .opacity(secondtextVisible ? 1 : 0)
//                              .animation(.easeInOut(duration: 3), value: secondtextVisible)
//                              .padding()
//                      }
//                  }
//                  .tag(1)
//                  .onAppear {
//                      secondtextVisible = true
//                      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                          withAnimation {
//                              selectedTab += 1
//                          }
//                      }
//                  }
//      
//                  ZStack {
//      
//                      VStack{
//                          Text("You can specify how long your calendar should be. ")
//                              .font(.custom("HelveticaNeue", size: 54))
//                              .foregroundColor(.white)
//                              .opacity(thirdtextVisible ? 1 : 0)
//                              .animation(.easeInOut(duration: 3), value: thirdtextVisible)
//                              .padding()
//      
//                      }
//                  }
//                  .tag(2)
//                  .onAppear {
//                      thirdtextVisible = true
//                      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                          withAnimation {
//                              selectedTab += 1
//                          }
//                      }
//                  }
//                  ZStack {
//                      VStack{
//                          Text("Each day you can open one door. Each door has a different challenge.  ")
//                              .font(.custom("HelveticaNeue", size: 54))
//                              .foregroundColor(.white)
//                              .opacity(fourthtextVisible ? 1 : 0)
//                              .animation(.easeInOut(duration: 3), value: fourthtextVisible)
//                              .padding()
//                      }
//                  }
//                  .tag(3)
//                  .onAppear {
//                      fourthtextVisible = true
//                      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                          withAnimation {
//                              selectedTab += 1
//                          }
//                      }
//                  }
//                  ZStack {
//                      VStack{
//                          Text("When you complete your challenge you can attach a photo , a quote , or you can write a note to your door.  ")
//                              .font(.custom("HelveticaNeue", size: 54))
//                              .foregroundColor(.white)
//                              .opacity(fifthtextVisible ? 1 : 0)
//                              .animation(.easeInOut(duration: 3), value: fifthtextVisible)
//                              .padding()
//      
//                      }
//                  }
//                  .tag(4)
//                  .onAppear {
//                      fifthtextVisible = true
//                      DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
//                          withAnimation {
//                              selectedTab += 1
//                          }
//                      }
//                  }
//                  ZStack {
//                      VStack{
//                          Text("When you are done with your challenge you can share it with your friends and family.")
//                              .font(.custom("HelveticaNeue", size: 54))
//                              .foregroundColor(.white)
//                              .opacity(sxithtextVisible ? 1 : 0)
//                              .animation(.easeInOut(duration: 3), value: sxithtextVisible)
//                              .padding()
//      
//                          Spacer()
//                          HStack {
//                              Text("Interesting ? Lets' do it")
//                                  .font(.custom("HelveticaNeue", size: 34))
//                                  .opacity(seventhtextVisible ? 1 : 0)
//                                  .animation(.easeInOut(duration: 3), value: seventhtextVisible)
//                                  .padding()
//                              Spacer()
//                              if seventhtextVisible {
//                                  Button (action: {
//                                      selectedTab = 6
//                                  }){
//                                      Circle()
//                                          .fill(Color.yellow)
//                                          .frame(width: 60, height: 60)
//                                          .overlay(
//                                              Image(systemName: "arrow.right")
//                                                  .foregroundColor(.black)
//                                                  .font(.title)
//                                          )
//                                          .padding(.trailing, 20) // Add padding from the edge
//                                          .padding(.bottom, 20)   // Add padding from the bottom
//                                  }
//                              }
//                          }
//                      }
//                  }
//                  .tag(5)
//                  .onAppear {
//                      sxithtextVisible = true
//                      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                          withAnimation {
//                              seventhtextVisible = true
//
//                          }
//                      }
//      
//                  }
        ZStack {
          Color("BackgroundColor")
            .edgesIgnoringSafeArea(.all)
          VStack(spacing: 20) {
            VStack {
              Text("Calendar Name")
                .font(.custom("HelveticaNeue", size: 34))
                .foregroundColor(.primary)
              TextField("Enter Calendar Name", text: $calendarName)
                .padding(12)
                .foregroundColor(.white)  // Text color
                .font(.system(size: 16, weight: .regular))  // Adjust font size and weight
                .background(
                  RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)  // Background matches screen
                )
                .frame(width: 280, height: 50)
                .overlay(
                  RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1)  // Brighter border
                    .shadow(color: Color.blue.opacity(0.6), radius: 10)  // Subtle glow
                )
                .accentColor(.blue)  // Caret color
                .padding(.horizontal, 20)
              Spacer().frame(height: 50)

              // Number of Doors Input
              VStack {
                Text("Number of Doors")
                  .font(.custom("HelveticaNeue", size: 34))
                  .foregroundColor(.primary)
                  
                  HStack {
                      Button(action :{
                          numberOfDoors -= 1
                      }) {
                          Image(systemName:"minus")
                              .padding()
                              .frame(width: 50, height: 50)
                              .background(Color.blue)
                              .foregroundColor(Color.white)
                              .cornerRadius(100)
                      }
                      .padding(.leading,70)
                      Spacer()
                      Text(numberOfDoors > 1 ? "\(numberOfDoors) doors" :"\(numberOfDoors) door").padding(40)
                      Spacer()
                      Button(action :{
                          numberOfDoors += 1
                      }) {
                          Image(systemName:"plus")
                              .padding()
                              .frame(width: 50, height: 50)
                              .background(Color.blue)
                              .foregroundColor(Color.white)
                              .cornerRadius(100)
                      }.padding(.trailing,70)
                      
                  }
              }
              Spacer().frame(height: 50)
                Button(action: {
                    Task {
                        let doors = viewModel.createDoors(
                            totalDoors: numberOfDoors,
                            startDate: Date(),
                            challenges: challenges
                        )
                        await MainActor.run {
                            viewModel.createCalendar(
                                name: calendarName,
                                doors: doors,
                                startDate: Date(),
                                challenges: challenges
                            )
                            selectedTab = 7 // Move to next tab after saving
                        }
                    }
                }) {
                    Text("Create Calendar")
                        .font(.custom("HelveticaNeue", size: 34))
                        .frame(width: 280, height: 70)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                        )
                        .foregroundColor(.white)
                        .padding()
                }

              }.buttonStyle(PlainButtonStyle())
            }
        } .tag(6)
        ZStack {
          VStack {
            Text(calendarName)
              .font(.largeTitle)
              .padding()

            LazyVGrid(
              columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10
            ) {
                ForEach(viewModel.doors) { door in
                DoorView(
                  door: door,
                  canOpen: viewModel.canOpen(door: door),
                  onOpen: {
                    viewModel.openDoor(door)
                  },
                  challenge: door.challenge
                )

              }
            }
            .padding()
          }
        } .tag(7)
        .onAppear {
//            let fetchDescriptor = FetchDescriptor<Door>()
//            if let fetchedDoors = try? modelContext.fetch(fetchDescriptor) {
//                viewModel.doors = fetchedDoors
//                print("Fetched doors: \(fetchedDoors.count)")
//                     for door in fetchedDoors {
//                         print("Door \(door.number): \(door.date), isOpened: \(door.isOpened)")
//                     }
//                 } else {
//                     print("No doors found")
//                 }
        }
       
      

    }
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    .preferredColorScheme(.dark)
    .ignoresSafeArea()

  }
}


#Preview {
  CalendarView()
}
