//
//  ToggleTaskIntent.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//
import AppIntents
import WidgetKit

struct ToggleTaskIntent: AppIntent {

    // Title shown in shortcuts / widget system
    static var title: LocalizedStringResource = "Toggle Task"

    @Parameter(title: "Task ID")
    var id: String        // 👈 MUST be String, NOT IntentParameter<String>

    // Required empty init for AppIntents
    init() {}

    // Convenience init so you can write ToggleTaskIntent(id: ...)
    init(id: String) {
        self.id = id
    }

    func perform() async throws -> some IntentResult {
        if let uuid = UUID(uuidString: id) {
            TaskManager.shared.toggleTask(id: uuid)

            WidgetCenter.shared.reloadAllTimelines()

            // 👇 small delay ensures sync before notification
            try? await Task.sleep(nanoseconds: 200_000_000)

            NotificationCenter.default.post(name: .taskListUpdated, object: nil)
        }
        return .result()
    }

}
