//
//  DoorView.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 11.01.25.
//
import SwiftUI

struct DoorView: View {
    @Environment(\.modelContext) private var modelContext
    @State var door: Door
    @State private var showContentEditor: Bool = false // For editing the door's data
    @State private var showImageOverlay: Bool = false // For showing the saved image and quote
    let canOpen: Bool
    var onOpen: () -> Void
    var challenge: Challenge?

    var body: some View {
        ZStack {
            if door.isOpened {
                // Display the opened door (yellow rectangle)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.yellow)
                    .overlay(
                        Text("Tap to View")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        // Show the saved image and quote
                        showImageOverlay = true
                    }
                    .fullScreenCover(isPresented: $showImageOverlay) {
                        // Full-screen view to show the saved image and quote
                        ZStack {
                            if let imageData = door.image, let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .edgesIgnoringSafeArea(.all)
                            } else {
                                Color.black.edgesIgnoringSafeArea(.all)
                            }
                            VStack {
                                Spacer()
                                Text(door.quote ?? "No Quote Yet")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(
                                        Color.black.opacity(0.6)
                                            .cornerRadius(10)
                                            .padding(.horizontal)
                                    )
                                    .padding(.bottom, 40)
                            }
                            // Close button for full-screen cover
                            VStack {
                                HStack {
                                    Button(action: {
                                        showImageOverlay = false
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.red)
                                            .background(.black)
                                        
                                            .padding()
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
            } else {
                // Display the unopened door (green rectangle)
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .frame(width: 70, height: 70)
                    .foregroundColor(canOpen ? .green : .gray)
                    .overlay(
                        Text("\(door.number)")
                            .font(.title)
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        if canOpen {
                            // Show the ContentEditorView sheet
                            showContentEditor = true
                        }
                    }
            }
        }
        .sheet(isPresented: $showContentEditor) {
            ContentEditorView(
                initialQuote: door.quote ?? "",
                initialImage: door.image != nil ? UIImage(data: door.image!) : nil,
                onSave: { image, quote in
                    print("onSave called with image and quote:")
                    print("Quote: \(quote)")
                    if let image = image {
                        print("Image size: \(image.jpegData(compressionQuality: 0.8)?.count ?? 0) bytes")
                    }

                    // Update the door
                    door.quote = quote
                    if let image = image {
                        door.image = image.jpegData(compressionQuality: 0.8)
                    }
                    door.isOpened = true

                    // Save to modelContext
                    do {
                        try modelContext.save()
                        print("Data saved successfully!")
                    } catch {
                        print("Failed to save data: \(error)")
                    }
                }
            )
        }
    }
}

#Preview {
    DoorView(door: Door(number: 1, date: Date(), isOpened: false),
             canOpen: true,
             onOpen: { print("Door opened!") },
             challenge: Challenge(id: 1, text: "Run 5km"))
}


//struct DoorView: View {
//    @Environment(\.modelContext) private var modelContext
//    @State var door: Door
//    @State private var isAnimationRunning: Bool = false
//    @State var showContentEditor: Bool = false
//    let canOpen: Bool
//    var onOpen: () -> Void
//    var challenge: Challenge?
//
//    var body: some View {
//        ZStack {
//            if door.isOpened {
//                RoundedRectangle(cornerRadius: 10)
//                    .frame( width: isAnimationRunning ? 250: 70, height: isAnimationRunning ? 250: 70)
//                    .foregroundColor(.yellow)
//                    .overlay(
//                        VStack{
//                            Text("Todays Challenge is")
//                                .padding()
//                            
//                            Text(challenge?.text ?? "🎉")
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                                .scaleEffect(isAnimationRunning ? 1.5 : 1.0)
//                                .rotationEffect(.degrees(isAnimationRunning ? 360 : 0))
//                                .padding()
//                        }
//                    )
//                    .onAppear {
//                        withAnimation(.easeInOut(duration: 0.8)){
//                            isAnimationRunning = true
//                        }
//                    }
//                    .onTapGesture {
//                        if canOpen {
//                            withAnimation(.easeInOut(duration: 0.8)) {
//                                isAnimationRunning = false
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                                door.isOpened.toggle()
//                            }
//                        }
//                           
//
//                      
//                    }
//                
//                
//            } else {
//                RoundedRectangle(cornerRadius: 10, style: .circular)
//                    .frame(width: 70, height: 70)
//                    .foregroundColor(canOpen ? .green : .gray)
//                    .overlay(
//                        Text("\(door.number)")
//                            .font(.title)
//                            .foregroundColor(.white)
//                    )
//                    .onTapGesture {
//                        if canOpen {
//                            print("second if \(canOpen)")
//                            withAnimation(.easeInOut(duration: 0.8)){
//                                isAnimationRunning = true
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                                onOpen()
//                                door.isOpened.toggle()
//                            }
//
//                        }
//                    }
//               
//            }
//        }  .sheet(isPresented: $showContentEditor) {
//            ContentEditorView(
//                initialQuote: door.quote ?? "",
//                initialImage: door.image != nil ? UIImage(data: door.image!) : nil,
//                onSave: { image, quote in
//                    door.quote = quote
//                    if let image = image {
//                        door.image = image.jpegData(compressionQuality: 0.8)
//                    }
//                    door.isOpened = true
//                    do {
//                        try modelContext.save()
//                    } catch {
//                        print("Error saving: \(error)")
//                    }
//                    
//                }
//            )
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}
//
//
//#Preview {
//    DoorView(door: Door(number: 1,date: Date(), isOpened: false),
//             canOpen: true,
//             onOpen: { print("Door opened!")},
//             challenge: Challenge(id:1,text: "Run 5km" ))
//}
