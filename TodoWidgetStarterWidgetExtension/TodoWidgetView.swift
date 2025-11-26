import SwiftUI
import WidgetKit
import AppIntents

struct TodoWidgetView: View {
    var entry: TodoEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Today")
                .bold()
                .font(.headline)

            // Show at most 5 tasks from shared storage
            ForEach(entry.tasks.prefix(5)) { task in
                HStack {
                    // 👇 This is now consistent with ToggleTaskIntent
                    Button(intent: ToggleTaskIntent(id: task.id.uuidString)) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .blue)
                    }

                    Text(task.title)
                        .strikethrough(task.isCompleted)
                }
            }

            // "+" only opens the app in "add" mode, no dummy "New Task"
            Button {
                // optional: force widget refresh
                WidgetCenter.shared.reloadAllTimelines()
            } label: {
                Text("+ Add Task")
                    .foregroundColor(.blue)
            }
            .widgetURL(URL(string: "todoapp://add")!)
        }
        .padding()
    }
}

