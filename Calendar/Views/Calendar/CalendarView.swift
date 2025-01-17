import SwiftUI
import SwiftData

struct CalendarView: View {
    @State private var selectedTab = 0
    @State private var calendarName: String = ""
    @State private var numberOfDoors: Int = 1
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel : CalendarViewModel
    @AppStorage("firstCalendarCreated") private var firstCalendarCreated: Bool = false
    @AppStorage("timeleftToOpen") private var timeleftToOpen: String = ""
    @State private var draggingDoor: Door? = nil // Track the currently dragged door
    
    init() {
        _viewModel = StateObject(wrappedValue: CalendarViewModel(modelContext: Environment(\.modelContext).wrappedValue))
    }
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                CreateCalendarView(
                    calendarName: $calendarName,
                    numberOfDoors: $numberOfDoors,
                    onCreate: {
                        Task {
                            let doors = viewModel.createDoors(totalDoors: numberOfDoors, startDate: Date())
                            await MainActor.run {
                                viewModel.createCalendar(
                                    name: calendarName,
                                    startDate: Date(), doors: doors
                                )
                                firstCalendarCreated = true
                                selectedTab = 1
                            }
                        }
                    }
                )
                
                
                CalendarContentView(
                    calendarName: calendarName,
                    viewModel: viewModel
                )
                .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .preferredColorScheme(.dark)
            .navigationTitle(selectedTab == 1 ? "Calendar" : "Create Calendar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//    var body: some View{
////        if !firstCalendarCreated {
////            WelcomeFirstTime(selectedTab: $selectedTab) {
////                firstCalendarCreated = true // Mark as completed
////            }
////        } else {
//            NavigationView {
//                TabView(selection: $selectedTab) {
//                    ZStack {
//                        Color("BackgroundColor")
//                            .edgesIgnoringSafeArea(.all)
//                        VStack(spacing: 20) {
//                            VStack {
//                                Text("Calendar Name")
//                                    .font(.custom("HelveticaNeue", size: 34))
//                                    .foregroundColor(.primary)
//
//                                TextField("Enter Calendar Name", text: $calendarName)
//                                    .padding(12)
//                                    .foregroundColor(.white)
//                                    .font(.system(size: 16, weight: .regular))
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .fill(Color.black)
//                                    )
//                                    .frame(width: 280, height: 50)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
//                                            .shadow(color: Color.blue.opacity(0.6), radius: 10)
//                                    )
//                                    .accentColor(.blue)
//                                    .padding(.horizontal, 20)
//
//                                Spacer().frame(height: 50)
//
//                                VStack {
//                                    Text("Number of Doors")
//                                        .font(.custom("HelveticaNeue", size: 34))
//                                        .foregroundColor(.primary)
//
//                                    HStack {
//                                        Button(action: {
//                                            if numberOfDoors > 1 {
//                                                numberOfDoors -= 1
//                                            }
//                                        }) {
//                                            Image(systemName: "minus")
//                                                .padding()
//                                                .frame(width: 50, height: 50)
//                                                .background(Color.blue)
//                                                .foregroundColor(.white)
//                                                .cornerRadius(100)
//                                        }
//
//                                        Spacer()
//
//                                        Text("\(numberOfDoors) \(numberOfDoors == 1 ? "door" : "doors")")
//                                            .padding(40)
//
//                                        Spacer()
//
//                                        Button(action: {
//                                            numberOfDoors += 1
//                                        }) {
//                                            Image(systemName: "plus")
//                                                .padding()
//                                                .frame(width: 50, height: 50)
//                                                .background(Color.blue)
//                                                .foregroundColor(.white)
//                                                .cornerRadius(100)
//                                        }
//                                    }
//                                }
//
//                                Spacer().frame(height: 50)
//
//                                Button(action: {
//                                    Task {
//                                        let doors = viewModel.createDoors(
//                                            totalDoors: numberOfDoors,
//                                            startDate: Date()
//                                        )
//
//                                        await MainActor.run {
//                                            viewModel.createCalendar(
//                                                name: calendarName,
//                                                doors: doors,
//                                                startDate: Date(),
//                                                challenges: []
//                                            )
//                                            firstCalendarCreated = true
//                                            selectedTab = 1
//                                        }
//                                    }
//                                }) {
//                                    Text("Create Calendar")
//                                        .font(.custom("HelveticaNeue", size: 34))
//                                        .frame(width: 280, height: 70)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .fill(Color.blue)
//                                        )
//                                        .foregroundColor(.white)
//                                        .padding()
//                                }
//                            }
//                        }
//                    }
//                    .tag(0)
//
//                    // Tab 1: Calendar View
//                    ZStack {
//                        VStack {
//                            Text(calendarName)
//                                .font(.largeTitle)
//                                .padding()
//
//                            LazyVGrid(
//                                columns: Array(repeating: GridItem(.flexible()), count: 4),
//                                spacing: 10
//                            ) {
//                                ForEach($viewModel.doors) { $door in
//                                    DoorView(
//                                        door: $door,
//                                        canOpen: viewModel.canOpen(door: door),
//                                        onOpen: {
//                                            viewModel.openDoor(door)
//                                        }
//                                    )
//                                    .onDrag {
//                                        draggingDoor = door
//                                        return NSItemProvider(object: "\(door.id)" as NSString)
//                                    }
//                                    .onDrop(
//                                        of: [.text],
//                                        delegate: DoorDropDelegate(
//                                            item: door,
//                                            current: $draggingDoor,
//                                            doors: $viewModel.doors
//                                        )
//                                    )
//                                }
//                            }
//                            .padding()
//                            
//                            Button (action : {
//                                viewModel.timeUntilNextDoor()
//                            }){
//                                Text("Click on me")
//                            }
//                        }
//                    }
//                    .tag(1)
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                .preferredColorScheme(.dark)
//                .navigationTitle(selectedTab == 1 ? "Calendar" : "Create Calendar")
//                .navigationBarTitleDisplayMode(.inline)
//            }
//        }
//    }
////}
//
#Preview {
    CalendarView()
}
