//
//  DoorCreateAndEditView.swift
//  Calendar
//
//  Created by Hanno Wiesen on 18.01.25.
//
import SwiftUI

struct DoorCreateAndEditView: View {
    @Binding var door: Door
    
    var body: some View {
        Form {
            TextField("Challange", text: self.$door.challenge)
            DatePicker("Date", selection: self.$door.unlockDate, displayedComponents: .date)
        }
    }
}
