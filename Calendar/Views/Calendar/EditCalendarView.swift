//
//  EditCalendarView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 17.01.25.
//

import SwiftUI

struct EditCalendarView: View {
    @State var calendarName: String
    @State var numberOfDoors: Int
    let onSave: (String, Int) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Calendar Name")) {
                    TextField("Enter Calendar Name", text: $calendarName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Section(header: Text("Number of Doors")) {
                    Stepper(value: $numberOfDoors, in: 1...100) {
                        Text("\(numberOfDoors) \(numberOfDoors == 1 ? "door" : "doors")")
                    }
                }
            }
            .navigationTitle("Edit Calendar")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    onSave(calendarName, numberOfDoors)
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    EditCalendarView(calendarName: "my calendar", numberOfDoors: 11, onSave: {_,_ in 
        print("hi")
    }
        )
}
