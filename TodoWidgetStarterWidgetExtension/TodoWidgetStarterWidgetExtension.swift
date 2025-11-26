//
//  TodoWidgetStarterWidgetExtension.swift
//  TodoWidgetStarterWidgetExtension
//
//  Created by Omkar Nikam on 24/11/25.
//
import WidgetKit
import SwiftUI

@main
struct TodoWidgetStarterWidgetExtension: Widget {
    let kind: String = "TodoWidgetStarterWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetView(entry: entry)
        }
        .configurationDisplayName("Today’s Tasks")
        .description("View and check off your to-dos right from your home screen.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryRectangular, // optional
            .accessoryInline       // optional
        ])

    }
}
