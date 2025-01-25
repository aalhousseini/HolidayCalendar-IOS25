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
    @State private var isVisible: Bool = false
    @State private var showAlert: Bool = false // Track alert visibility
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if calendars.isEmpty {
                    Text("No calendars found.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .opacity(isVisible ? 1 : 0) // Animate opacity
                        .animation(.easeInOut(duration: 0.5), value: isVisible)
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
                                    
                                    alertTitle = "Calendar Deleted"
                                    alertMessage = "The calendar '\(calendar.name)' has been successfully deleted."
                                    showAlert = true
                                    modelContext.delete(calendar)
                                   // deleteCalendar(calendar)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                
                                if !calendar.isImported {
                                    Button {
                                        exportCalendar(calendar: calendar)
                                        alertTitle = "Calendar Exported"
                                        alertMessage = "Calendar '\(calendar.name)' has been successfully exported."
                                        showAlert = true

                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                    }
                                }
                            }
                        }
                    }
                }
            } .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                // Actions to perform when the view appears
                withAnimation(.easeInOut(duration: 2)) {
                    isVisible = true
                }
                
                print("CalendarListView appeared!")
            }
            .onDisappear {
                // Reset the visibility or other states when the view disappears
                isVisible = false
                timer?.invalidate() // Stop any running timers
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
    private func deleteCalendar(_ calendar: CalendarModel) {
        modelContext.delete(calendar)
        print("Calendar \(calendar.name)")
        do {
            try modelContext.save()
            alertTitle = "Calendar Deleted"
            alertMessage = "The calendar '\(calendar.name)' has been successfully deleted."
            showAlert = true
            print("Delete successful, showAlert: \(showAlert)") // Debugging
        } catch {
            alertTitle = "Delete Failed"
            alertMessage = "An error occurred while deleting the calendar."
            showAlert = true
            print("Error deleting calendar: \(error.localizedDescription)") // Debugging
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
