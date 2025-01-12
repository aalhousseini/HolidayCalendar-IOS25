//
//  SignUP.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 05.01.25.
//

import SwiftUI

struct SignUP: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var username: String = ""
    @State var name: String = ""
    @AppStorage("isLoggedIn")  var isLoggedIn = false
    @AppStorage("nameStorage") var nameStorage : String = ""
    @State var localstorage = SwiftDataSaver()
    @State private var shouldShake = false // for shake animation
    @State private var fadeOut = false // For fade-out animation
    @State private var showSuccessCheckmark = false // show green check mark
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.modelContext) private var modelContext
    
    struct ShakeEffect: GeometryEffect {
        var animatableData: CGFloat

        func effectValue(size: CGSize) -> ProjectionTransform {
            ProjectionTransform(CGAffineTransform(translationX: 10 * sin(animatableData * .pi * 2), y: 0))
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack{
            
            if (isLoggedIn) {
                Mainpage()
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.5), value: isLoggedIn)
            } else {
                
                VStack() {
                    Image(.agreement)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    Text("Enter your information")
                        .font(.custom("HelveticaNeue-Light", size: 30))
                    VStack(spacing : 20) {
                        TextField("Email", text: $email)
                            .padding(.horizontal, 10)
                            .frame(width: 300, height: 50)
                            .overlay(
                                RoundedRectangle(cornerSize:CGSize(width: 4, height: 4))
                                    .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                            )
                        SecureField("Password", text: $password)
                            .padding(.horizontal, 10)
                            .frame(width: 300, height: 50)
                            .overlay(
                                RoundedRectangle(cornerSize:CGSize(width: 4, height: 4))
                                    .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                            )
                        TextField("Name", text: $name)
                            .padding(.horizontal, 10)
                            .frame(width: 300, height: 50)
                            .overlay(
                                RoundedRectangle(cornerSize:CGSize(width: 4, height: 4))
                                    .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                            )
                        TextField("Username", text: $username)
                            .padding(.horizontal, 10)
                            .frame(width: 300, height: 50)
                            .overlay(
                                RoundedRectangle(cornerSize:CGSize(width: 4, height: 4))
                                    .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                            )
                        
                        Button (action : {
                            nameStorage = name
                            viewModel.signUp(username: username, name: name,email: email, password: password, modelContext:modelContext) { success in
                                if success {
                                    withAnimation {
                                        fadeOut = true
                                        showSuccessCheckmark = true
                                        localstorage.fetchAllUsers(modelContext: modelContext)
                                        
                                    }
                                    // Update state on success
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isLoggedIn = true // Navigate to Mainpage
                                    }
                                }
                            }
                        }) {
                            Text("Sign Up")
                                .padding(.horizontal, 10)
                                .frame(width: 300, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerSize:CGSize(width: 4, height: 4))
                                        .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                                )
                            
                        }
                        if viewModel.showError, let errorMessage = viewModel.errorMessage {
                            ErrorMessage(message:  errorMessage)
                        }
                        HStack {
                            Text("Already have an account?")
                            NavigationLink(destination: LogIn()) {
                                Text("Sign In")
                                    .underline()
                            }
                            
                        }
                        
                        .font(.caption)
                        .padding(.horizontal, 10)
                    }
                }
                    .modifier(shouldShake ? ShakeEffect(animatableData: CGFloat(3)) : ShakeEffect(animatableData: 0)) // Apply shake effect
                    .opacity(fadeOut ? 0.0 : 1.0) // Fade out animation
                    .animation(.easeInOut(duration: 0.5), value: fadeOut)
                    
                    if showSuccessCheckmark {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.green)
                            .transition(.scale)
                            .animation(.easeInOut(duration: 0.5), value: showSuccessCheckmark)
                }
            }
            }
        } .navigationViewStyle(StackNavigationViewStyle())
        
  
    }
}

#Preview {
    SignUP()
}
