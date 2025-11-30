//
//  CountEntry.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 30/11/25.
//


import WidgetKit
import SwiftUI

struct CountEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct CountProvider: TimelineProvider {
    func placeholder(in context: Context) -> CountEntry {
        CountEntry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (CountEntry) -> Void) {
        completion(CountEntry(date: Date(), count: loadCount()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CountEntry>) -> Void) {
        let entry = CountEntry(date: Date(), count: loadCount())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    // read from shared app storage
    private func loadCount() -> Int {
        TaskManager.shared.loadTasks().filter { !$0.isCompleted }.count
    }
}

struct CountLockView: View {
    var entry: CountEntry
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: entry.count == 0 ? "checkmark.circle.fill" : "bell.fill")
                .font(.system(size: 18))
                .foregroundColor(entry.count == 0 ? .green : .yellow)
            
            Text("\(entry.count)")
                .font(.system(size: 20, weight: .bold))
        }
        .widgetURL(URL(string: "todoapp://open")!)
    }
}

struct TodoCountLockWidget: Widget {
    let kind = "TodoCountLockWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountProvider()) { entry in
            CountLockView(entry: entry)
        }
        .configurationDisplayName("Pending Tasks")
        .description("Shows only task count on lock screen.")
        .supportedFamilies([
            .accessoryCircular,      // 🔥 Lock screen style
            .accessoryInline,
            .accessoryRectangular
        ])
    }
}
