//
//  DoorView.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//
import SwiftUI

struct DoorView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var door: DoorModel
    
   
    @State private var animateOpacity: Bool = false
    @State private var showDetailView: Bool = false // For showing the detail view
    @State private var showContentEditor: Bool = false // For editing the door's data
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            if door.isLocked {
                // Locked door appearance
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .overlay(
                        VStack {
                            Text("\(door.number + 1)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text("🔒 Locked")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    )
                    .onTapGesture {
                        triggerShake() // Indicate door cannot be opened
                    }
            } else if !door.isCompleted {
                // Unlocked but unopened door
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 70)
                    .foregroundColor(!door.isLocked ? .green : .yellow)
                    .overlay(
                        VStack {
                            Text("\(door.number + 1)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text(!door.isLocked ? "🔓 Tap to Open" : "🔓")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    )
                    .onTapGesture {
                        if !door.isLocked {
                            showContentEditor = true
                        } else {
                            triggerShake()
                        }
                    }
//                    .sheet(isPresented: $showContentEditor, onDismiss: {
//                        // Check the door's state after closing the content editor
//                        if door.isCompleted {
//                            showDetailView = true
//                        }
//                    }) {
//                        if !door.isImported {
//                            ContentEditorView(door: $door)
//                        } else {
//                            DetailView(door: door)
//                        }
//                    }
                    .sheet(isPresented: $showContentEditor, onDismiss: {
                        // Check the door's state after closing the content editor
                        if door.isCompleted {
                            showDetailView = true
                        }
                    }) {
                        // Show ContentEditorView only if the door is not imported
                        if !door.isImported {
                            ContentEditorView(door: $door)
                        } else {
                            DetailView(door: door)
                        }
                    }
                    .sheet(isPresented: $showDetailView) {
                        // Show DetailView if the door is completed or imported
                        DetailView(door: door)
                    }



            } else {
                // Completed door
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.yellow)
                    .overlay(
                        VStack {
                            Text("\(door.number + 1)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text("✅ Completed")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            showDetailView = true // Show detail view
                        }
                    }
                    .sheet(isPresented: $showDetailView) {
                        DetailView(door: door)
                    }
            }
        }
        .offset(x: shakeOffset)
    }

    private func triggerShake() {
        // Animation to indicate door cannot be opened
        let shakeDistance: CGFloat = 10 // Distance of each shake
        withAnimation(.easeInOut(duration: 0.1)) {
            shakeOffset = -shakeDistance // Move left
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = shakeDistance // Move right
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) {
                shakeOffset = 0 // Return to original position
            }
        }
    }
}

#Preview {
    let challenge = "Run 5km"
    DoorView(door: .constant(DoorModel(number: 1, unlockDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, challenge: challenge)))
}

