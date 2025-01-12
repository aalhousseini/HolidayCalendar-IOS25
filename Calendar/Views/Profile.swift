import SwiftUI
import PhotosUI

struct Profile: View {
    var body: some View {
        NavigationView {
            ProfileForm()
        }
    }
}

struct ProfileForm: View {
    @AppStorage("nameStorage") var nameStorage: String = ""
    @StateObject var viewModel = ProfileModel()
    
    var body: some View {
        ZStack {
            Color(.systemBackground) // Adaptive background
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                EditableCircularProfileImage(viewModel: viewModel)
                
                Spacer()
                
                Group {
                    TextField("Name", text: $viewModel.name, prompt: Text("Name"))
                        .textFieldStyle(ProfileTextFieldStyle())
                    
                    TextField("Username", text: $viewModel.username, prompt: Text("\(nameStorage)"))
                        .textFieldStyle(ProfileTextFieldStyle())
                    
                    TextField("About Me", text: $viewModel.email, prompt: Text("About Me"))
                        .textFieldStyle(ProfileTextFieldStyle())
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        // Logout action
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(ProfileButtonStyle(color: .red))
                    
                    Button(action: {
                        // Save action
                    }) {
                        Text("Save")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(ProfileButtonStyle(color: .blue))
                }
                
                .navigationTitle("Account Settings")
            }
            .padding()
        }.preferredColorScheme(.dark)
    }
}

struct ProfileTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(10)
            .frame(height: 70)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary, lineWidth: 1)
            )
            .padding(.vertical, 8)
    }
}

struct ProfileButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .frame(width: 100, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1)
            )
            .padding(.horizontal, 10)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

#Preview {
    Profile()
}

