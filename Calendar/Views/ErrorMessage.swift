//
//  ErrorMessage.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 08.01.25.
//

import SwiftUI

struct ErrorMessage: View {
    let message: String
    var body: some View {
        Text(message)
                   .font(.headline)
                   .foregroundColor(.red)
                   .padding()
                   .background(Color.red.opacity(0.1))
                   .cornerRadius(10)
                   .shadow(radius: 5)
                   .transition(.move(edge: .top).combined(with: .opacity))
                   .animation(.spring(), value: message) // Smooth animation
    }
}

#Preview {
    ErrorMessage(message: "This is an error")
}
