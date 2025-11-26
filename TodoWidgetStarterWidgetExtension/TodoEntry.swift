//
//  TodoEntry.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//

import WidgetKit
import Foundation

struct TodoEntry: TimelineEntry {
    let date: Date
    let tasks: [TodoItem]
}
