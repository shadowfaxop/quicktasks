import Foundation
import AppIntents

// Intent to add a new task from the widget
struct AddTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Task"

    // Title for the new task
    @Parameter(title: "Title")
    var titleText: String

    init() { self.titleText = "" }

    // Convenience init to match Button(intent: AddTaskIntent(title: "New Task")) usage
    init(title: String) {
        self.titleText = title
    }

    func perform() async throws -> some IntentResult {
        // TODO: Wire this to your shared model/store via App Groups or AppIntents infrastructure
        // For now, just succeed.
        return .result()
    }
}

// Intent to toggle a task's completion from the widget
struct ToggleTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task"

    // The task identifier (UUID string)
    @Parameter(title: "Task ID")
    var id: String

    init() { self.id = "" }

    // Convenience init to match Button(intent: ToggleTaskIntent(id: someString)) usage
    init(id: String) {
        self.id = id
    }

    func perform() async throws -> some IntentResult {
        // TODO: Toggle the task with this id in your shared model/store
        return .result()
    }
}
