//
//  DetailView.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 14.01.25.
//

import SwiftUI

struct DetailView: View {
    var image: UIImage?
    var quote: String
    var challenge: Challenge?
    @AppStorage("showInfo") var showInfo = false

    var body: some View {

        ZStack {
            // Background Image
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Image(uiImage: .mediation)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                // Placeholder background
            }

            // Overlay Card
            VStack {
                Spacer() // Push content to the bottom
                ScrollView {
                    Spacer().frame(height: 600)
                    VStack(alignment: .leading, spacing: 10) {
                        Spacer()
                        // Challenge Name
                        Text(challenge?.text ?? "No Challenge Assigned")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)

                        // Quote or Description
                        Text(quote.isEmpty ? "No quote yet." : quote)
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                    }
                    .frame(minWidth: 400, maxWidth: 400)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.7)) // Semi-transparent black
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20) // Spacing from the bottom edge
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DetailView(
        image: UIImage(named: "mediation"), // Replace with an actual asset or nil for testing
        quote: "This is an example quote about the challenge. ahhaha ah ah ah a hah. This is an additional text to test multiline behavior and scrolling. It should be visible and scrollable properly.",
        challenge: Challenge(id: 1, text: "Run 5km")
    )
}
