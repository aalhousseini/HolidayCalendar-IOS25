import SwiftUI
import SwiftData

struct CalendarCreateView: View {
    @State private var calendarName: String = ""
    @State private var numberOfDoors: Int = 1
    
    @State private var draggingDoor: Door? = nil
    
    @AppStorage("firstCalendarCreated") private var firstCalendarCreated: Bool = false
    @AppStorage("timeleftToOpen") private var timeleftToOpen: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            ZStack {
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
                                Spacer()
                                Button {
                                    numberOfDoors > 1 ?  numberOfDoors -= 1 : ()
                                } label: {
                                    Image(systemName: "minus")
                                        .padding()
                                        .frame(width: 50, height: 50)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(100)
                                }
                                Spacer()
                                Text("\(numberOfDoors) \(numberOfDoors == 1 ? "door" : "doors")")
                                Spacer()
                                Button {
                                    numberOfDoors += 1
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

                        Button {
                            let newCalendar = CalendarModel(name: calendarName, startDate: Date(), doors: [])
                            modelContext.insert(newCalendar)

                            do {
                                try modelContext.save()
                                print("Calendar successfully saved: \(newCalendar.id)")
                            } catch {
                                print("Error saving calendar: \(error)")
                            }
                            
                            firstCalendarCreated = true
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
                }
            }
            .navigationTitle("Create Calendar")
        }
    }
}

#Preview {
    CalendarCreateView()
}
