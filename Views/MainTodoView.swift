//
//  MainTodoView.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//
//
//  MainTodoView.swift
//  TodoWidgetStarter
//

import SwiftUI

struct MainTodoView: View {

    @FocusState private var textFieldFocused: Bool

    @State private var text = ""
    @State private var tasks: [TodoItem] = TaskManager.shared.loadTasks()

    @State private var showDeleteAlert = false
    @State private var taskToDelete: TodoItem?

    @State private var selectedTab = 0

    func refresh() {
        tasks = TaskManager.shared.loadTasks()
    }

    var body: some View {
        TabView(selection: $selectedTab) {

            // -------- TAB 1: REMINDERS --------
            NavigationView {
                VStack {

                    // Input Row
                    HStack {
                        TextField("Add Task...", text: $text)
                            .textFieldStyle(.roundedBorder)
                            .focused($textFieldFocused)

                        Button("Add") {
                            guard !text.isEmpty else { return }
                            TaskManager.shared.addTask(title: text)
                            text = ""
                            refresh()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()

                    // Task List
                    List {
                        ForEach(tasks) { task in
                            HStack {
                                Button {
                                    TaskManager.shared.toggleTask(id: task.id)
                                    refresh()
                                } label: {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .primary)
                                        .font(.system(size: 22))
                                }

                                Text(task.title)
                                    .strikethrough(task.isCompleted)
                                    .foregroundColor(task.isCompleted ? .gray : .primary)
                                    .padding(.leading, 4)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete { indexSet in
                            taskToDelete = tasks[indexSet.first!]
                            showDeleteAlert = true
                        }
                    }
                }
                .navigationTitle("Today's Tasks")
                .alert("Delete this task?", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        if let task = taskToDelete {
                            TaskManager.shared.deleteTask(id: task.id)
                            refresh()
                        }
                    }
                }
            }
            .tabItem {
                Label("Reminders", systemImage: "checklist")
            }
            .tag(0)

            // -------- TAB 2: FAVORITES --------
            placeholderTab(title: "Favorites Coming Soon...", icon: "star.fill", color: .yellow)
                .tabItem { Label("Favorites", systemImage: "star") }
                .tag(1)

            // -------- TAB 3: CALENDAR --------
            placeholderTab(title: "Calendar View Coming Soon...", icon: "calendar", color: .orange)
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(2)

            // -------- TAB 4: SETTINGS --------
            placeholderTab(title: "Settings Coming Soon...", icon: "gearshape.fill")
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(3)
        }
        .onReceive(NotificationCenter.default.publisher(for: .taskListUpdated)) { _ in
            refresh()
        }

        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) { _ in
            refresh()
        }

        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("WidgetSync"))) { _ in
            refresh()
        }
        .onReceive(NotificationCenter.default.publisher(for: .focusAddField)) { _ in
            textFieldFocused = true
        }
        .onAppear(perform: refresh)
        .onAppear {
            refresh()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            refresh()
        }
    }

    // MARK: - Placeholder View
    func placeholderTab(title: String, icon: String, color: Color = .gray) -> some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(color)

            Text(title)
                .font(.headline)
        }
    }
}


// MARK: - Global Notification Names
extension Notification.Name {
    static let focusAddField = Notification.Name("focusAddField")
}
