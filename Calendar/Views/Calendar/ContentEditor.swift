import SwiftUI
import PhotosUI
import SwiftData

struct ContentEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var quote: String = "" // State to hold the user's text input
    @State private var selectedImage: UIImage? = nil // State to hold the selected image
    @State private var selectedPhotoPickerItem: PhotosPickerItem? = nil // Photo picker item
    @State private var showTextEditor: Bool = false // Toggles TextEditor visibility
    @State private var showInfo: Bool = false // Toggles showing saved Text
    @State private var navigateToDetailView: Bool = false // Toggles navigation to the detailed view
    var onSave: (UIImage?, String) -> Void // Callback to save data

       init(initialQuote: String, initialImage: UIImage?, onSave: @escaping (UIImage?, String) -> Void) {
           self._quote = State(initialValue: initialQuote)
           self._selectedImage = State(initialValue: initialImage)
           self.onSave = onSave
       }
    @Query var users: [User]
    @Query var doors: [DoorEntry]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color adapts to light/dark mode
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Title
                    Text("Capture Your Day")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.primary)
                        .padding(.top, 40)
                    
                    Text("Share a Photo or Write About It!")
                        .font(.headline)
                        .foregroundColor(Color.secondary)
                    
                    // Display selected image or placeholder
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
                    
                    // Show TextEditor or saved Text
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
                    } else if showInfo {
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
                        // Upload button
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
                        
                        // Add quote button
                        Button(action: {
                            showTextEditor = true
                            showInfo = false
                           
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
                        
                        // Save button
                        Button(action: {
                            showTextEditor = false
                            showInfo = true
                            onSave(selectedImage, quote)
                            navigateToDetailView = true // Trigger navigation
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
                
                // Navigation to DetailView
                NavigationLink(
                    destination: DetailView(image: selectedImage, quote: quote),
                    isActive: $navigateToDetailView
                ) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .preferredColorScheme(.light)
    }
    
    func saveData() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        let entry = DoorEntry(quote: quote, imageData: imageData)
        modelContext.insert(entry)
        do {
            try modelContext.save()
            print("Entry Saved")
        } catch {
            print("Failed because of this: \(error)")
        }
    }
}

 struct DetailView: View {
    var image: UIImage?
    var quote: String

    var body: some View {
        ZStack {
            // Full-screen image
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill() // Ensures the image covers the full screen
                    .edgesIgnoringSafeArea(.all) // Extends to edges of the screen
            } else {
                Color.black.edgesIgnoringSafeArea(.all) // Fallback background
            }

            // Overlay content
            VStack {
                Spacer() // Push text to the bottom
                Text(quote.isEmpty ? "No Quote" : quote)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(
                        Color.black.opacity(0.6) // Semi-transparent background for better contrast
                            .cornerRadius(10)
                            .padding(.horizontal)
                    )
                    .padding(.bottom, 40) // Add spacing from the bottom
            }
        }
        .navigationBarBackButtonHidden(true) // Optional: Customize back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Back action
                 //   showInfo = false
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
            }
        }
    }
}


#Preview {
    ContentEditorView(
        initialQuote: "Sample quote",             // Mock quote
        initialImage: UIImage(named: "example"), // Replace "example" with a valid asset name, or use nil
        onSave: { image, quote in
            print("Saved Image: \(String(describing: image))")
            print("Saved Quote: \(quote)")
        }
    )
}
