//
//  DoorListView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//
import SwiftUI
import SwiftData

struct CalendarListView: View {
    @Query var calendars: [CalendarModel]
    @Environment(\.modelContext) private var modelContext
    @State private var draggingDoor: Door? = nil
    @State private var updatedDoors: [Door] = []

    var body: some View {
        NavigationView {
            VStack {
                if calendars.isEmpty {
                    Text("No calendars found.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(calendars) { calendar in
                            Section {
                                DisclosureGroup(calendar.name) {
                                    LazyVGrid(
                                        columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3),
                                        spacing: 20
                                    ) {
                                        ForEach(updatedDoors) { door in
                                            DoorView(
                                                door: .constant(door),
                                                canOpen: !door.isLocked,
                                                onOpen: {
                                                    print("Door \(door.number + 1) opened!")
                                                }
                                            )
                                            .onDrag {
                                                draggingDoor = door
                                                return NSItemProvider(object: NSString(string: "\(door.id)"))
                                            }
                                            .onDrop(
                                                of: [.text],
                                                delegate: DoorDropDelegate(
                                                    item: door,
                                                    current: $draggingDoor,
                                                    doors: $updatedDoors
                                                )
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .onAppear {
                                        updatedDoors = calendar.doors
                                    }
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(calendar)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Your Calendars")
        }
    }
}


#Preview {
    CalendarListView()
}
