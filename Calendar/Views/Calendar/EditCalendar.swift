//import SwiftUI
//
//struct EditCalendarView: View {
//    let calendarId: UUID
//    @State var calendarName: String
//    @State var numberOfDoors: Int
//    @StateObject private var viewModel = CalendarViewModel()
//    @Environment(\.dismiss) var dismiss // To close the sheet after saving
//
//    var body: some View {
//        VStack {
//            Text("Edit Calendar")
//                .font(.largeTitle)
//                .padding()
//
//            TextField("Calendar Name", text: $calendarName)
//                .padding()
//                .background(Color.secondary.opacity(0.2))
//                .cornerRadius(8)
//
//            HStack {
//                Button(action: {
//                    numberOfDoors = max(1, numberOfDoors - 1)
//                }) {
//                    Image(systemName: "minus.circle")
//                        .font(.title2)
//                }
//
//                Text("\(numberOfDoors) Doors")
//                    .font(.headline)
//
//                Button(action: {
//                    numberOfDoors += 1
//                }) {
//                    Image(systemName: "plus.circle")
//                        .font(.title2)
//                }
//            }
//            .padding()
//
//            Button("Save Changes") {
////                viewModel.updateCalendarById(
////                    calendarId,
////                    newName: calendarName,
////                    newTotalDoors: numberOfDoors,
////                    challenges: viewModel.challenges // Ensure challenges are set up in CalendarViewModel
////                )
////                dismiss() // Close the sheet after saving
//                print("Doors:", viewModel.doors)
//
//                viewModel.timeUntilNextDoor()
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//        }
//        .padding()
//    }
//}
//
//#Preview {
//
//
//    EditCalendarView(calendarId:  UUID(uuidString: "A949493D-9473-40F2-8269-6F967C42D5BD") ?? UUID(), calendarName: "My Calendar", numberOfDoors: 10)
//}
