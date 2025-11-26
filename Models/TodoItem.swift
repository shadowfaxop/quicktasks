//
//  Task.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//


import Foundation

struct TodoItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}
