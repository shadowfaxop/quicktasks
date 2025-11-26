//
//  TaskManager.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//

//
//  TaskManager.swift
//  TodoWidgetStarter
//

import Foundation
import WidgetKit

class TaskManager {
    static let shared = TaskManager()

    private let storageKey = "tasks"
    private let appGroupID = "group.com.shadowfaxop.TodoWidgetShared"

    private var storage: UserDefaults {
        UserDefaults(suiteName: appGroupID)!
    }

    func loadTasks() -> [TodoItem] {
        if let data = storage.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            return decoded
        }
        return []
    }

    func saveTasks(_ tasks: [TodoItem]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            storage.set(encoded, forKey: storageKey)

            // 🔥 Force widget update
            WidgetCenter.shared.reloadAllTimelines()

            // 🔥 Tell the running app to refresh immediately
            NotificationCenter.default.post(name: Notification.Name.taskListUpdated, object: nil)

            // 🔥 Also notify when widget triggers change
            NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
            
            // 👇 NEW — Notify app instantly
            NotificationCenter.default.post(name: Notification.Name.taskListUpdated, object: nil)
        }
    }

    func addTask(title: String) {
        var tasks = loadTasks()
        tasks.append(TodoItem(id: UUID(), title: title, isCompleted: false))
        saveTasks(tasks)
    }

    func toggleTask(id: UUID) {
        var tasks = loadTasks()
        if let index = tasks.firstIndex(where: { $0.id == id }) {
            tasks[index].isCompleted.toggle()
            saveTasks(tasks)
        }
    }

    func deleteTask(id: UUID) {
        let tasks = loadTasks().filter { $0.id != id }
        saveTasks(tasks)
    }
}

extension Notification.Name {
    static let taskListUpdated = Notification.Name("taskListUpdated")
}

