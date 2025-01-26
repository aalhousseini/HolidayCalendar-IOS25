//
//  ThankYou.swift
//  Unlock Fit
//
//  Created by Al Housseini, Ahmad on 26.01.25.
//

import SwiftUI

struct ThankYou: View {
    let message: String
    var body: some View {
        Text(message)
                   .font(.headline)
                   .foregroundColor(.green)
                   .padding()
                   .background(.green.opacity(0.1))
                   .cornerRadius(10)
                   .shadow(radius: 5)
                   .transition(.move(edge: .top).combined(with: .opacity))
                   .animation(.spring(), value: message) // Smooth animation
    }
}

#Preview {
    ThankYou(message: "Thx")
}
