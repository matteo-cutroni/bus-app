//
//  BusTimeWidgetLiveActivity.swift
//  BusTimeWidget
//
//  Created by Matteo Cutroni on 21/11/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BusTimeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BusTimeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BusTimeWidgetAttributes.self) { context in
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

extension BusTimeWidgetAttributes {
    fileprivate static var preview: BusTimeWidgetAttributes {
        BusTimeWidgetAttributes(name: "World")
    }
}

extension BusTimeWidgetAttributes.ContentState {
    fileprivate static var smiley: BusTimeWidgetAttributes.ContentState {
        BusTimeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BusTimeWidgetAttributes.ContentState {
         BusTimeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BusTimeWidgetAttributes.preview) {
   BusTimeWidgetLiveActivity()
} contentStates: {
    BusTimeWidgetAttributes.ContentState.smiley
    BusTimeWidgetAttributes.ContentState.starEyes
}
