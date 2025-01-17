//
//  DoorView.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//


//
//  DoorView.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//
import SwiftUI

struct DoorView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var door: Door
    @State private var showDetailView: Bool = false // For showing the detail view
    @State private var showContentEditor: Bool = false // For editing the door's data
    @State private var shakeOffset: CGFloat = 0
//    @StateObject private var viewModel = CalendarViewModel()
//    @AppStorage("timeleftToOpen") private var timeleftToOpen: String = ""
    let canOpen: Bool
    var onOpen: () -> Void

    var body: some View {
        ZStack {
            if door.isOpened {
                // Opened door with yellow color and "Tap to View" text
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.yellow)
                    .overlay(
                        VStack {
                            Text("Tap to View")
                                .font(.caption)
                                .foregroundColor(.white)
                            if let challenge = door.challenge {
                                Text("Today's Challenge:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                                Text(challenge.text)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                    )
                    .onTapGesture {
                        // Navigate to DetailView when the door is already opened
                        showDetailView = true
                    }
                    .sheet(isPresented: $showDetailView) {
                        DetailView(door: door)
                    }
            } else {
                // Unopened door with green or gray color based on canOpen
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .frame(width: 80, height: 80)
                    .foregroundColor(canOpen ? .green : .gray)
                    .overlay(
                        VStack {
                            Text("\(door.number)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            Text(canOpen ? "🔓" : "🔒")
                                .font(.largeTitle)
                        }
                    )
                    .offset(x: shakeOffset)
                    .onTapGesture {
                        if canOpen {
                            // Show the ContentEditorView sheet for unopened doors
                            showContentEditor = true
                            door.isOpened = true
//                            timeleftToOpen = viewModel.timeUntilNextDoor() ??  "NA"
                        } else {
                            triggerShake()
                        }
                    }
            }
        }
        .sheet(isPresented: $showContentEditor) {
            ContentEditorView(door: $door)
        }
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
    let challenge = ChallengeLoader.loadRandomChallenge()
    DoorView(door: .constant(Door(number: 1, date: Date(), isOpened: false, challenge: challenge)),
             canOpen: true,
             onOpen: { print("Door opened!") })
}

//import SwiftUI
//
//struct DoorView: View {
//    @Environment(\.modelContext) private var modelContext
//    @State var door: Door
//    @State private var showContentEditor: Bool = false // For editing the door's data
//    @State private var showImageOverlay: Bool = false // For showing the saved image and
//    @State private var shakeOffset: CGFloat = 0
//    @StateObject private var viewModel = CalendarViewModel()
//    @AppStorage("timeleftToOpen") private var timeleftToOpen: String = ""
//    let canOpen: Bool
//    var onOpen: () -> Void
//    
//    //var challenge: Challenge?
//
//    var body: some View {
//        ZStack {
//            if door.isOpened {
//                
//                RoundedRectangle(cornerRadius: 10)
//                    .frame(width: 70, height: 70)
//                    .foregroundColor(.yellow)
//                    .overlay(
//                        VStack {
//                            Text("Tap to View")
//                                .font(.caption)
//                                .foregroundColor(.white)
//                            if let challenge = door.challenge {
//                                Text("Today's Challenge:")
//                                    .font(.headline)
//                                    .foregroundColor(.white)
//                                    .padding(.top, 5)
//                                Text(challenge.text)
//                                    .font(.subheadline)
//                                    .foregroundColor(.white)
//                                    .multilineTextAlignment(.center)
//                                    .padding(.horizontal)
//                            } else {
//                                Text("No Challenge Assigned")
//                                    .font(.subheadline)
//                                    .foregroundColor(.white)
//                            }
//                        }
//                    )
//                    .onTapGesture {
//                        // Show the saved image and quote
//                        showImageOverlay = true
//                    }
//                    .sheet(isPresented: $showImageOverlay) {
//                        ZStack {
//                            // Background: Image or Placeholder
//                            if let imageData = door.image, let image = UIImage(data: imageData) {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .edgesIgnoringSafeArea(.all)
//                            } else {
//                                Color.black.edgesIgnoringSafeArea(.all)
//                            }
//                            
//                            // Overlay: Quote Display
//                            VStack {
//                                Spacer()
//                                Text(door.quote ?? "No Quote Yet")
//                                    .font(.largeTitle)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.white)
//                                    .multilineTextAlignment(.center)
//                                    .padding()
//                                    .background(
//                                        Color.black.opacity(0.6)
//                                            .cornerRadius(10)
//                                            .padding(.horizontal)
//                                    )
//                                    .padding(.bottom, 40)
//                            }
//                        }
//                        .presentationDetents([.large]) // Optional: control the sheet height
//                        .presentationDragIndicator(.visible)   // Show a drag indicator at the top of the sheet
//                    }
//                
//                
//                
//            } else {
//                // Display the unopened door (green rectangle)
//                RoundedRectangle(cornerRadius: 10, style: .circular)
//                    .frame(width: 80, height: 80)
//                    .foregroundColor(canOpen ? .green : .gray)
//                    .overlay(
//                        VStack {
//                            Text("\(door.number)")
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                            Text(canOpen ? "🔓" : "🔓")
//                                .font(.largeTitle)
//                        }
//                        
//                    ) .offset(x: shakeOffset)
//                    .onTapGesture {
//                        if canOpen {
//                            // Show the ContentEditorView sheet
//                            timeleftToOpen = viewModel.timeUntilNextDoor() ?? "default value"
//                            print("Opening Door \(door.number). Challenge: \(door.challenge?.text ?? "No Challenge")")
//                            showContentEditor = true
//                        } else {
//                            triggerShake()
//                        }
//                    }
//            }
//        }
//        .sheet(isPresented: $showContentEditor) {
//            ContentEditorView(door: $door)
////            ContentEditorView(
////                initialQuote: door.quote ?? "",
////                initialImage: door.image != nil ? UIImage(data: door.image!) : UIImage(named: "mediation"),
////                challenge: door.challenge,
////                onSave: { image, quote in
////                    print("onSave called with image and quote:")
////                    print("Quote: \(quote)")
////                    if let image = image {
////                        print("Image size: \(image.jpegData(compressionQuality: 0.8)?.count ?? 0) bytes")
////                    }
////                    
////                    // Update the door
////                    door.quote = quote
////                    if let image = image {
////                        door.image = image.jpegData(compressionQuality: 0.8)
////                    } else {
////                        if let defaultImage = UIImage(named: "mediation") {
////                            door.image = image?.jpegData(compressionQuality: 0.8)
////                        }
////                    }
////                    door.isOpened = true
////                    
////                    if let challenge = door.challenge {
////                           print("Challenge persists: \(challenge.text)")
////                       } else {
////                           print("Warning: No challenge is set for this door!")
////                       }
////                    // Save to modelContext
////                    do {
////                        try modelContext.save()
////                        print("Data saved successfully! in door view")
////                    } catch {
////                        print("Failed to save data: \(error)")
////                    }
////                }
////            )
//        }
//    }
//        private func triggerShake() {
//            let shakeDistance: CGFloat = 10 // Distance of each shake
//            withAnimation(.easeInOut(duration: 0.1)) {
//                shakeOffset = -shakeDistance // Move left
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                withAnimation(.easeInOut(duration: 0.1)) {
//                    shakeOffset = shakeDistance // Move right
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                withAnimation(.easeInOut(duration: 0.1)) {
//                    shakeOffset = 0 // Return to original position
//                }
//            }
//        }
//    }
//    
//
//
//
//#Preview {
//    let challenge = ChallengeLoader.loadRandomChallenge()
//    DoorView(door: Door(number: 1, date: Date(), isOpened: false, challenge: challenge),
//             canOpen: true,
//             onOpen: { print("Door opened!") })
//}
