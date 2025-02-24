
import SwiftUI
import SwiftData

struct CalendarCreateView: View {
    @State private var calendarName: String = ""
    @State private var doors: [DoorModel] = []
    @State private var navigateToListView = false // State to control navigation
    @Binding var selectedTab: Int
    @AppStorage("firstCalendarCreated") private var firstCalendarCreated: Bool = false
    @AppStorage("timeleftToOpen") private var timeleftToOpen: String = ""
    @AppStorage("firstCalendar")  var firstCalendar = true
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
            NavigationStack {
                VStack {
                    Text("Calendar Name")
                        .font(.custom("HelveticaNeue", size: 34))
                        .foregroundColor(.primary)
                    
                    TextField("Enter Calendar Name", text: $calendarName)
                        .padding(12)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .regular))
                        .frame(width: 280, height: 50)
                        .accentColor(.blue)
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                .shadow(color: Color.blue.opacity(0.6), radius: 10)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                    
                    Spacer().frame(height: 50)
                    
                    VStack {
                        Text("Number of Doors")
                            .font(.custom("HelveticaNeue", size: 34))
                            .foregroundColor(.primary)
                        HStack {
                            Spacer()
                            Button {
                                self.removeDoor()
                            } label: {
                                Image(systemName: "minus")
                                    .padding()
                                    .frame(width: 50, height: 50)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(100)
                            }
                            Spacer()
                            Text("\(self.doors.count) \(self.doors.count == 1 ? "door" : "doors")")
                            Spacer()
                            Button {
                                self.addDoor()
                            } label: {
                                Image(systemName: "plus")
                                    .padding()
                                    .frame(width: 50, height: 50)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(100)
                            }
                            Spacer()
                        }
                    }
                    Spacer().frame(height: 50)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                        ForEach(0..<doors.count, id: \.self) { index in
                            NavigationLink {
                                DoorCreateAndEditView(door: self.$doors[index])
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.blue)
                                    .overlay(
                                        Text("\(self.doors[index].number)")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                    }
                    
                    
                    Spacer()
                    
                    // Button to create a calendar and navigate
                    Button {
                        let newCalendar = CalendarModel(name: calendarName, startDate: Date(), doors: doors)
                        
                        for door in doors {
                            door.calendar = newCalendar
                        }
                        
                        modelContext.insert(newCalendar)
                        
                        do {
                            try modelContext.save()
                            print("Calendar successfully saved: \(newCalendar.id)")
                        } catch {
                            print("Error saving calendar: \(error)")
                        }
                        
                        for door in newCalendar.doors {
                            createDoorNotification(door: door)
                        }
                        withAnimation(.easeInOut(duration: 0.5)) {
                            selectedTab = 1
                        }
                        
                        firstCalendarCreated = true
                        navigateToListView = true
                        calendarName = ""
                        doors = []
                    } label: {
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
                .navigationTitle("Create Calendar")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    
    private func addDoor() -> Void {
        let newDoor = DoorModel(
            number: self.doors.count,
            unlockDate: Calendar.current.date(byAdding: .day, value: self.doors.count, to: Date())!,
            challenge: ChallengeLoader.loadRandomChallenge()
        )
        
        self.doors.append(newDoor)
    }
    
    private func removeDoor() -> Void {
        if doors.count > 0 {
            self.doors.removeLast()
        }
    }
}

//#Preview {
//    CalendarCreateView(selectedTab: 1)
//}
