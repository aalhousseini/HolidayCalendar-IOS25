//
//  DoorDetailView.swift
//  Calendar
//
//  Created by Hanno Wiesen on 18.01.25.
//
import SwiftUI
import PhotosUI

struct DoorDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State var door: Door
    
    @State private var doorQuote: String = ""
            
    @State private var selectedPhotoPickerItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage?

    var body: some View {
        if door.isLocked {
            Text("🔒")
                .font(.largeTitle)
            Text("Come back later")
        } else {
            ZStack {
                List {
                    LabeledContent {
                        Text("\(self.door.number)")
                    } label: {
                        Text("Number")
                    }
                    LabeledContent {
                        Text("\(self.door.challenge)")
                    } label: {
                        Text("Challange")
                    }
                    LabeledContent {
                        Text(self.door.unlockDate, style: .date)
                    } label: {
                        Text("Date")
                    }
                    LabeledContent {
                        Text("\(self.door.quote ?? "no quote")")
                    } label: {
                        Text("Quote")
                    }
                    if let imageData = self.door.image {
                        Image(uiImage: UIImage(data: imageData) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            if self.door.isCompleted {
                Form {
                    TextField("Quote", text: self.$doorQuote)
                    PhotosPicker(selection: $selectedPhotoPickerItem, matching: .images, photoLibrary: .shared()) {
                        Text("Select Image")
                        
                    }
                    .onChange(of: selectedPhotoPickerItem) { _, newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                            }
                        }
                    }
                    
                    Button {
                        do {
                            self.door.quote = self.doorQuote
                            
                            if let image = selectedImage {
                                door.image = image.jpegData(compressionQuality: 0.8)
                            }
                            
                            self.modelContext.insert(self.door)
                            try self.modelContext.save()
                        } catch {
                            print("Error")
                        }
                    } label: {
                        Text("Save")
                    }
                }
                .onAppear {
                    self.doorQuote = door.quote ?? ""
                }
            }
            Spacer()
            Button {
                do {
                    self.door.isCompleted = true
                    self.modelContext.insert(door)
                    
                    try self.modelContext.save()
                } catch {
                    
                }
            } label: {
                Text("Complete")
            }

        }
    }
}
