//
//  DetailView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 14.01.25.
//

import SwiftUI

struct DetailView: View {
    var door : DoorModel
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            if let imageData = door.image, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Image(uiImage: .mediation)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
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

                        Text(door.quote ?? ""  )
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
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
    }
}

#Preview {
    let door =  DoorModel(number: 1, unlockDate: Date(), challenge: "Challange")
    
    DetailView( door: door)
}
