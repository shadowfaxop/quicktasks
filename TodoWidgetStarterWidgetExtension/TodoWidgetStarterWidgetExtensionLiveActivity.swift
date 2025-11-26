//
//  TodoWidgetStarterWidgetExtensionLiveActivity.swift
//  TodoWidgetStarterWidgetExtension
//
//  Created by Omkar Nikam on 24/11/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TodoWidgetStarterWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TodoWidgetStarterWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodoWidgetStarterWidgetExtensionAttributes.self) { context in
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

extension TodoWidgetStarterWidgetExtensionAttributes {
    fileprivate static var preview: TodoWidgetStarterWidgetExtensionAttributes {
        TodoWidgetStarterWidgetExtensionAttributes(name: "World")
    }
}

extension TodoWidgetStarterWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: TodoWidgetStarterWidgetExtensionAttributes.ContentState {
        TodoWidgetStarterWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TodoWidgetStarterWidgetExtensionAttributes.ContentState {
         TodoWidgetStarterWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TodoWidgetStarterWidgetExtensionAttributes.preview) {
   TodoWidgetStarterWidgetExtensionLiveActivity()
} contentStates: {
    TodoWidgetStarterWidgetExtensionAttributes.ContentState.smiley
    TodoWidgetStarterWidgetExtensionAttributes.ContentState.starEyes
}
