////
////  CalendarViews2.swift
////  Calendar
////
////  Created by Al Housseini, Ahmad on 16.01.25.
////
//
//import SwiftUI
//
//struct CalendarViews2: View {
//    @State  var calendarName: String
//    @State  var numberOfDoors: Int
//    @StateObject private var viewModel : CalendarViewModel
//    @State private var draggingDoor: Door? = nil
//    init(){
//        _viewModel = StateObject(wrappedValue: CalendarViewModel(modelContext: Environment(\.modelContext).wrappedValue))
//    }
//    var body: some View {
//        ZStack {
//            VStack {
//                Text(calendarName)
//                    .font(.largeTitle)
//                    .padding()
//                
//                LazyVGrid(
//                    columns: Array(repeating: GridItem(.flexible()), count: 4),
//                    spacing: 10
//                ) {
//                    ForEach($viewModel.doors) { $door in
//                        DoorView(
//                            door: $door,
//                            canOpen: viewModel.canOpen(door: door),
//                            onOpen: {
//                                viewModel.openDoor(door)
//                            }
//                        )
//                        .onDrag {
//                            draggingDoor = door
//                            return NSItemProvider(object: "\(door.id)" as NSString)
//                        }
//                        .onDrop(
//                            of: [.text],
//                            delegate: DoorDropDelegate(
//                                item: door,
//                                current: $draggingDoor,
//                                doors: $viewModel.doors
//                            )
//                        )
//                    }
//                }
//                .padding()
//            }
//        }.preferredColorScheme(.dark)
//    }
//    struct DoorDropDelegate: DropDelegate {
//        let item: Door
//        @Binding var current: Door?
//        @Binding var doors: [Door]
//        
//        func dropEntered(info: DropInfo) {
//            guard let current = current,
//                  current.id != item.id,
//                  let fromIndex = doors.firstIndex(where: { $0.id == current.id }),
//                  let toIndex = doors.firstIndex(where: { $0.id == item.id }) else { return }
//            
//            withAnimation {
//                doors.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
//            }
//        }
//        
//        func performDrop(info: DropInfo) -> Bool {
//            current = nil
//            return true
//        }
//    }
//    
//}
//#Preview {
//    CalendarViews2
//}
import SwiftUI
import SwiftData

struct CreateCalendarView: View {
    @Binding var calendarName: String
    @Binding var numberOfDoors: Int
    let onCreate: () -> Void

    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                VStack {
                    Text("Calendar Name")
                        .font(.custom("HelveticaNeue", size: 34))
                        .foregroundColor(.primary)

                    TextField("Enter Calendar Name", text: $calendarName)
                        .padding(12)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .regular))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                        .frame(width: 280, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                .shadow(color: Color.blue.opacity(0.6), radius: 10)
                        )
                        .accentColor(.blue)
                        .padding(.horizontal, 20)

                    Spacer().frame(height: 50)

                    VStack {
                        Text("Number of Doors")
                            .font(.custom("HelveticaNeue", size: 34))
                            .foregroundColor(.primary)

                        HStack {
                            Button(action: {
                                if numberOfDoors > 1 {
                                    numberOfDoors -= 1
                                }
                            }) {
                                Image(systemName: "minus")
                                    .padding()
                                    .frame(width: 50, height: 50)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(100)
                            }

                            Spacer()

                            Text("\(numberOfDoors) \(numberOfDoors == 1 ? "door" : "doors")")
                                .padding(40)

                            Spacer()

                            Button(action: {
                                numberOfDoors += 1
                            }) {
                                Image(systemName: "plus")
                                    .padding()
                                    .frame(width: 50, height: 50)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(100)
                            }
                        }
                    }

                    Spacer().frame(height: 50)

                    Button(action: onCreate) {
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
                }
            }
        }
    }
}

#Preview {
    let name = "Test"
    CreateCalendarView(calendarName: .constant("hello"), numberOfDoors: .constant(11), onCreate: {
        print("Created")
    })
}
