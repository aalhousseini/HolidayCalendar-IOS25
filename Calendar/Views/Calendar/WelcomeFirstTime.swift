import SwiftUI

struct WelcomeFirstTime: View {
    @AppStorage("firstCalendar") private var firstCalendar = true
    @Binding var selectedTab: Int
    @State private var currentStep = 0 // Track the current step
    @State private var showText = false // General state for text visibility
    var onCompletion: () -> Void

    let messages = [
        "So now let's start with the fun part.",
        "We need to make sure that we have a good schedule.",
        "You can specify how long your calendar should be.",
        "Each day you can open one door. Each door has a different challenge.",
        "When you complete your challenge you can attach a photo, a quote, or write a note to your door.",
        "When you are done with your challenge you can share it with your friends and family. Interesting? Let's do it!"
    ]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(0..<messages.count, id: \.self) { index in
                ZStack {
                    VStack {
                        Text(messages[index])
                            .font(.custom("HelveticaNeue", size: 54))
                            .foregroundColor(.white)
                            .opacity(showText ? 1 : 0)
                            .animation(.easeInOut(duration: 2), value: showText)
                            .padding()
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                        if index == messages.count - 1 { // Last Slide
                            Button(action: {
                                firstCalendar = false
                                onCompletion()
                            }) {
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 60, height: 60)
                                    .overlay {
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.black)
                                            .font(.title)
                                    }
                                
                                    .padding()
                            }
                        }
                    }
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .preferredColorScheme(.dark)
        .onAppear {
            startSlides()
        }
    }

    private func startSlides() {
        let totalMessages = messages.count
        for index in 0..<totalMessages {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 5) {
                withAnimation {
                    selectedTab = index
                    showText = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showText = false
                }
            }
        }
    }
}

#Preview {
    WelcomeFirstTime(selectedTab: .constant(2)) {}
}
