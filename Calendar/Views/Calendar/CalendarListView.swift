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

    @State private var showImportSheet: Bool = false
    
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
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 20) {
                                        ForEach(calendar.doors) { door in
                                            DoorView(door: .constant(door))
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(calendar)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                Button {
                                    exportCalendar(calendar: calendar)
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showImportSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }.fileImporter(isPresented: $showImportSheet, allowedContentTypes: [.item], allowsMultipleSelection: false) { result in
                        switch result {
                        case .success(let fileUrl):
                            do {
                                guard let url = fileUrl.first else {
                                    fatalError()
                                }
                                
                                let object = importCalendar(url: url)
                                
                                guard let object = object else {
                                    fatalError()
                                }
                                
                                self.modelContext.insert(object)
                                try self.modelContext.save()
                                
                                for door in object.doors {
                                    createDoorNotification(door: door)
                                }
                            } catch {
                                fatalError()
                            }
                        case .failure(let error):
                            print(error)
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
