//
//  TaskEntity.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//


import AppIntents
import Foundation

struct TaskEntity: AppEntity, Identifiable {

    static var typeDisplayName: LocalizedStringResource = "Task"
    static var defaultQuery = TaskQuery()
    
    var id: UUID
    var title: String
    var isCompleted: Bool
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

struct TaskQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [TaskEntity] {
        return TaskManager.shared.tasks
            .filter { identifiers.contains($0.id) }
            .map { TaskEntity(id: $0.id, title: $0.title, isCompleted: $0.isCompleted) }
    }
    
    func suggestedEntities() async throws -> [TaskEntity] {
        return TaskManager.shared.tasks.map { TaskEntity(id: $0.id, title: $0.title, isCompleted: $0.isCompleted) }
    }
}
