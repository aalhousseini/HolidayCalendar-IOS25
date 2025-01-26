//
//  TimeLeftWidgetLiveActivity.swift
//  TimeLeftWidget
//
//  Created by Al Housseini, Ahmad on 26.01.25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimeLeftWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimeLeftWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeLeftWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimeLeftWidgetAttributes {
    fileprivate static var preview: TimeLeftWidgetAttributes {
        TimeLeftWidgetAttributes(name: "World")
    }
}

extension TimeLeftWidgetAttributes.ContentState {
    fileprivate static var smiley: TimeLeftWidgetAttributes.ContentState {
        TimeLeftWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TimeLeftWidgetAttributes.ContentState {
         TimeLeftWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TimeLeftWidgetAttributes.preview) {
   TimeLeftWidgetLiveActivity()
} contentStates: {
    TimeLeftWidgetAttributes.ContentState.smiley
    TimeLeftWidgetAttributes.ContentState.starEyes
}
