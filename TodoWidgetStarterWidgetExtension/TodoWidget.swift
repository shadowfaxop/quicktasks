//
//  TodoWidget.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 25/11/25.
//


import WidgetKit
import SwiftUI

struct TodoEntry: TimelineEntry {
    let date: Date
    // Add any widget data you plan to show here, e.g. tasks
    let tasks: [String]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TodoEntry {
        TodoEntry(date: Date(), tasks: ["Sample Task"]) 
    }

    func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> Void) {
        let entry = TodoEntry(date: Date(), tasks: ["Snapshot Task 1", "Snapshot Task 2"]) 
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodoEntry>) -> Void) {
        // Provide a simple timeline with one entry that refreshes in 30 minutes
        let entry = TodoEntry(date: Date(), tasks: ["Buy milk", "Walk the dog", "Write code"]) 
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct TodoWidgetView: View {
    let entry: TodoEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("To-Do")
                .font(.headline)
            ForEach(entry.tasks.prefix(3), id: \.self) { task in
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(.secondary)
                    Text(task)
                        .lineLimit(1)
                        .font(.subheadline)
                }
            }
            Spacer(minLength: 0)
        }
        .padding()
    }
}

struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { (entry: TodoEntry) in
            TodoWidgetView(entry: entry)
        }
        .configurationDisplayName("To-Do List")
        .description("Shows your latest tasks.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryRectangular, // optional
            .accessoryInline       // optional
        ])

    }
}
