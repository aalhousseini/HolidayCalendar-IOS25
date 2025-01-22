//
//  HolidayCalendarWidget.swift
//  HolidayCalendarWidget
//
//  Created by Al Housseini, Ahmad on 22.01.25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct HolidayCalendarWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct HolidayCalendarWidget: Widget {
    let kind: String = "HolidayCalendarWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            HolidayCalendarWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    HolidayCalendarWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}


//
//  HolidayCalendarWidget.swift
//  HolidayCalendarWidget
//
//  Created by Al Housseini, Ahmad on 22.01.25.
//
//
//import WidgetKit
//import SwiftUI
//
//struct Provider: AppIntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), timeLeft: "1d 5h 0m", isAllUnlocked: false)
//    }
//
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: configuration, timeLeft: "1d 5h 0m", isAllUnlocked: false)
//    }
//    
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var entries: [SimpleEntry] = []
//
//        // Fetch all calendars and find the next door to unlock
//        let calendars = fetchCalendars() // Replace with your data-fetching logic
//        if let nextDoor = calendars.nextDoorToUnlock {
//            let now = Date()
//            let unlockDate = nextDoor.unlockDate
//            
//            // Calculate the time left
//            let timeLeftComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: unlockDate)
//            let timeLeft = "\(timeLeftComponents.day ?? 0)d \(timeLeftComponents.hour ?? 0)h \(timeLeftComponents.minute ?? 0)m \(timeLeftComponents.second ?? 0)s"
//            
//            // Create the entry
//            let entry = SimpleEntry(date: now, configuration: configuration, timeLeft: timeLeft, isAllUnlocked: false)
//            entries.append(entry)
//            
//            // Refresh the timeline every second until the unlock date
//            let timeline = Timeline(entries: entries, policy: .after(unlockDate))
//            return timeline
//        } else {
//            // No locked doors
//            let entry = SimpleEntry(date: Date(), configuration: configuration, timeLeft: "All doors are unlocked!", isAllUnlocked: true)
//            entries.append(entry)
//            
//            let timeline = Timeline(entries: entries, policy: .never) // No updates needed if everything is unlocked
//            return timeline
//        }
//    }
//
//    // Mocked data-fetching function
//    private func fetchCalendars() -> [CalendarModel] {
//        // Replace this with real data fetching, e.g., from Core Data or App Group storage
//        return []
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationAppIntent
//    let timeLeft: String
//    let isAllUnlocked: Bool
//}
//
//struct HolidayCalendarWidgetEntryView: View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            if entry.isAllUnlocked {
//                Text("🎉 All doors are unlocked!")
//                    .font(.headline)
//                    .multilineTextAlignment(.center)
//            } else {
//                Text("Next door unlocks in:")
//                    .font(.caption)
//                Text(entry.timeLeft)
//                    .font(.title3)
//                    .bold()
//                    .multilineTextAlignment(.center)
//            }
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(10)
//    }
//}
//
//struct HolidayCalendarWidget: Widget {
//    let kind: String = "HolidayCalendarWidget"
//
//    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            HolidayCalendarWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//        .configurationDisplayName("Holiday Calendar")
//        .description("Shows the time left until the next door unlocks.")
//        .supportedFamilies([.systemSmall, .systemMedium])
//    }
//}
//
//extension ConfigurationAppIntent {
//    fileprivate static var mockIntent: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//}
//
//#Preview(as: .systemSmall) {
//    HolidayCalendarWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .mockIntent, timeLeft: "1d 2h 30m", isAllUnlocked: false)
//    SimpleEntry(date: .now, configuration: .mockIntent, timeLeft: "All doors are unlocked!", isAllUnlocked: true)
//}
