import SwiftUI
import WidgetKit
import AppIntents

struct TodoWidgetView: View {
    var entry: TodoEntry
    @Environment(\.widgetFamily) var family
    
    // Local animation tracking
    @State private var animatingTaskID: UUID?

    var maxVisible: Int {
        switch family {
        case .systemSmall: return 3
        case .systemMedium: return 6
        default: return 6
        }
    }
    
    // Show only incomplete tasks
    var activeTasks: [TodoItem] {
        entry.tasks.filter { !$0.isCompleted }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            

            // ---- Task List ----
            VStack(alignment: .leading, spacing: 8) {
                ForEach(activeTasks.prefix(maxVisible)) { task in
                    taskRow(task)
                }
                
                
                if activeTasks.count > maxVisible {
                    Text("+ \(activeTasks.count - maxVisible) more…")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // ---- Add Button ----
            HStack {
                Spacer() // keeps it right-aligned
                Link(destination: URL(string: "todoapp://add")!) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30))   // Bigger, tappable
                        .foregroundColor(.blue)
                        .padding(.all, 8)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                })

            }
        }
        .padding(18)
        .modifier(ContainerBackgroundCompat())
        .widgetURL(URL(string: "todoapp://open")!)
    }
    
    // MARK: Animated Row Component
    @ViewBuilder
    private func taskRow(_ task: TodoItem) -> some View {
        let isAnimating = animatingTaskID == task.id
        
        Button(intent: ToggleTaskIntent(id: task.id.uuidString)) {
            Text(task.title)
                .font(.body)
                .foregroundColor(isAnimating ? .gray : .primary)
                .strikethrough(isAnimating, color: .gray)
                .opacity(isAnimating ? 0.4 : 1.0)
                .animation(.easeInOut(duration: 0.25), value: isAnimating)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .onTapGesture {
            startAnimation(for: task)
        }
    }
    
    // MARK: Animation Handler
    private func startAnimation(for task: TodoItem) {
        animatingTaskID = task.id
        
        // fade-strike → wait → remove via system refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

private struct ContainerBackgroundCompat: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, *) {
            content.containerBackground(.background, for: .widget)
        } else {
            // Fallback for older SDKs where widget background style isn't available
            content.background(Color.clear)
        }
    }
}
