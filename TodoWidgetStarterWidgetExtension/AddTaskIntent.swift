//
//  AddTaskIntent.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//

import AppIntents
import WidgetKit

struct AddTaskIntent: AppIntent {

    // 👈 IMPORTANT: use LocalizedStringResource, not String
    static var title: LocalizedStringResource = "Add Task"

    @Parameter(title: "Task Title")
    var title: String

    // Required empty init
    init() {}

    // Convenience init used by the widget
    init(title: String) {
        self.title = title
    }

    func perform() async throws -> some IntentResult {
        TaskManager.shared.addTask(title: title)
        WidgetCenter.shared.reloadAllTimelines()   // keep widget in sync
        return .result()
    }
}

