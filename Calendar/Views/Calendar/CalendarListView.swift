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
    @State private var timeLeftForNextDoor: String = ""
    @State private var timer: Timer? = nil
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
                                DisclosureGroup {
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                                        ForEach(calendar.doors) { door in
                                            DoorView(door: .constant(door))
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                } label: {
                                    if calendar.isImported {
                                        Image(systemName: "square.and.arrow.down")
                                    }
                                    Text(calendar.name)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    modelContext.delete(calendar)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                
                                if !calendar.isImported {
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
    
    private func startCountdown(for door: DoorModel) {
        timer?.invalidate() // Stop any existing timer
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let now = Date()
            if door.unlockDate > now {
                let components = Calendar.current.dateComponents([.hour, .minute, .second], from: now, to: door.unlockDate)
                timeLeftForNextDoor = "\(components.day ?? 0)d \(components.hour ?? 0)h \(components.minute ?? 0)m \(components.second ?? 0)s"
            } else {
                timeLeftForNextDoor = "Unlocked"
                timer?.invalidate() // Stop the timer when the door is unlocked
            }
        }
    }
    
    private func handleImport(fileUrl: [URL]) {
        do {
            guard let url = fileUrl.first else { return }
            if let importedCalendar = importCalendar(url: url) {
                modelContext.insert(importedCalendar)
                try modelContext.save()
                
                for door in importedCalendar.doors {
                    createDoorNotification(door: door)
                }
            }
        } catch {
            print("Failed to import calendar: \(error)")
        }
    }}

#Preview {
    CalendarListView()
}
