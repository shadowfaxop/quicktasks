//
//  Provider.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//

import WidgetKit
import SwiftUI
import Foundation

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> TodoEntry {
        TodoEntry(date: Date(), tasks: TaskManager.shared.loadTasks())
    }

    func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> Void) {
        let entry = TodoEntry(date: Date(), tasks: TaskManager.shared.loadTasks())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodoEntry>) -> Void) {
        let entry = TodoEntry(date: Date(), tasks: TaskManager.shared.loadTasks())
        let next = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let tasks: [TodoItem]
}


struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetView(entry: entry)
        }
        .configurationDisplayName("Todo List")
        .description("Shows your remaining tasks.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryRectangular, // optional
            .accessoryInline       // optional
        ])

    }
}

