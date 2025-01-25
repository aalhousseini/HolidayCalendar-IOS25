//
//  DetailView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 14.01.25.
//

import SwiftUI

struct DetailView: View {
    var door : DoorModel
    @State private var isVisible: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            if let imageData = door.image, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(isVisible ? 1 : 0) // Fade-in animation
                    .animation(.easeInOut(duration: 0.3), value: isVisible)
            } else {
                Image(uiImage: .mediation)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(isVisible ? 1 : 0) // Fade-in animation
                    .animation(.easeInOut(duration: 0.3), value: isVisible)
            }
            VStack {
                Spacer()
                ScrollView {
                    Spacer().frame(height: 600)
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                        Text(door.challenge)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .opacity(isVisible ? 1 : 0) // Fade-in animation
                            .animation(.easeInOut(duration: 0.3).delay(0.1), value: isVisible)


                        Text(door.quote ?? ""  )
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .opacity(isVisible ? 1 : 0) // Fade-in animation
                                                        .animation(.easeInOut(duration: 0.3).delay(0.2), value: isVisible)
                    }
                    .frame(minWidth: 400, maxWidth: 400)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.7))
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
             withAnimation(.easeInOut(duration: 0.5)) {
                 isVisible = true // Trigger animation
             }
         }
         .onDisappear {
             isVisible = false // Reset state when dismissed
         }
     }
 }

#Preview {
    let door =  DoorModel(number: 1, unlockDate: Date(), challenge: "Challange")
    
    DetailView( door: door)
}
