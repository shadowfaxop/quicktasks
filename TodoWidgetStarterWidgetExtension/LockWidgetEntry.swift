//
//  LockWidgetEntry.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 30/11/25.
//
import WidgetKit
import SwiftUI

struct LockWidgetEntry: TimelineEntry {
    let date: Date
    let remainingCount: Int
}

struct LockWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> LockWidgetEntry {
        LockWidgetEntry(date: Date(), remainingCount: 3)
    }

    func getSnapshot(in context: Context, completion: @escaping (LockWidgetEntry) -> Void) {
        let count = TaskManager.shared.loadTasks().filter { !$0.isCompleted }.count
        completion(LockWidgetEntry(date: Date(), remainingCount: count))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LockWidgetEntry>) -> Void) {
        let tasks = TaskManager.shared.loadTasks()
        let count = tasks.filter { !$0.isCompleted }.count

        let entry = LockWidgetEntry(date: Date(), remainingCount: count)

        // refresh every 15 min or system decides
        let next = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}


// MARK: - 🔔 Minimal Lock Widget UI
struct LockScreenMinimalCountView: View {
    var entry: LockWidgetEntry

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
            
            VStack(spacing: 4) {
                Image(systemName: entry.remainingCount == 0 ? "checkmark.circle.fill" : "bell.fill")
                    .font(.system(size: 18))
                    .foregroundColor(entry.remainingCount == 0 ? .green : .yellow)

                Text("\(entry.remainingCount)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
        .widgetURL(URL(string: "todoapp://open")!)
    }
}


// MARK: - Widget Configuration
struct TodoLockScreenWidget: Widget {
    let kind = "TodoLockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LockWidgetProvider()) { entry in
            LockScreenMinimalCountView(entry: entry)
        }
        .configurationDisplayName("Tasks Remaining")
        .description("Shows number of pending tasks.")
        .supportedFamilies([
            .accessoryCircular,     // 🔥 Best style
            .accessoryInline,
            .accessoryRectangular
        ])
    }
}
