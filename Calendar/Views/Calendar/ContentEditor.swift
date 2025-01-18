import SwiftUI
import PhotosUI
import SwiftData

struct ContentEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var door: Door // Use a binding to persist door updates
    @State private var selectedImage: UIImage?
    @State private var quote: String
    @State private var selectedPhotoPickerItem: PhotosPickerItem? = nil
    @State private var showTextEditor: Bool = false

    init(door: Binding<Door>) {
        self._door = door
        self._quote = State(initialValue: door.wrappedValue.quote ?? "")
        self._selectedImage = State(initialValue: door.wrappedValue.image != nil ? UIImage(data: door.wrappedValue.image!) : nil)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // Challenge Display
                    Text("Today's challenge is:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primary)
                        .padding(.top, 40)

                    Text(door.challenge)
                        .font(.headline)
                        .foregroundColor(Color.secondary)

                    // Title
                    Text("Capture Your Day")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primary)
                        .padding(.top, 40)

                    Text("Share a Photo or Write About The Challenge!")
                        .font(.headline)
                        .foregroundColor(Color.secondary)

                    // Image Display
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.4), radius: 5)
                            .padding()
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(maxHeight: 300)
                            .overlay(
                                Text("No Image Selected")
                                    .foregroundColor(Color.secondary)
                                    .font(.headline)
                            )
                            .padding()
                    }

                    // Text Editor or Saved Text
                    if showTextEditor {
                        ZStack(alignment: .topLeading) {
                            if quote.isEmpty {
                                Text("Enter your quote here...")
                                    .foregroundColor(Color.secondary)
                                    .padding(.leading, 6)
                                    .padding(.top, 8)
                            }

                            TextEditor(text: $quote)
                                .foregroundColor(Color.primary)
                                .scrollContentBackground(.hidden)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.4), radius: 3)
                                .frame(height: 150)
                                .padding(.horizontal)
                        }
                    } else {
                        Text(quote.isEmpty ? "No quote saved yet." : quote)
                            .foregroundColor(Color.primary)
                            .padding()
                            .frame(height: 150, alignment: .topLeading)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.4), radius: 3)
                            .padding(.horizontal)
                    }

                    Spacer()

                    // Buttons
                    HStack(spacing: 40) {
                        // Upload Button
                        PhotosPicker(
                            selection: $selectedPhotoPickerItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            VStack {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.red)
                                Text("Upload")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.4), radius: 3)
                        }
                        .onChange(of: selectedPhotoPickerItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }

                        // Add Quote Button
                        Button(action: {
                            showTextEditor = true
                        }) {
                            VStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                Text("Write")
                                    .font(.footnote)
                                    .foregroundColor(.green)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.4), radius: 3)
                        }

                        // Save Button
                        Button(action: {
                            // Save updates to the door
                            door.isCompleted = true
                            door.quote = quote
                            if let image = selectedImage {
                                door.image = image.jpegData(compressionQuality: 0.8)
                            }

                            do {
                                try modelContext.save()
                                print("Door updated successfully!")
                            } catch {
                                print("Failed to save door: \(error)")
                            }
                        }) {
                            VStack {
                                Image(systemName: "tray.and.arrow.down")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                                Text("Save")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                            .frame(width: 80, height: 80)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.4), radius: 3)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    let door = Door(
        number: 1,
        unlockDate: Date(),
        quote: "Stay healthy!",
        image: UIImage(named: "example")?.jpegData(compressionQuality: 0.8),
        challenge: "Run 5km"
    )

    ContentEditorView(door: .constant(door))
}
