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
