//
//  TodoWidgetStarterWidgetExtensionBundle.swift
//  TodoWidgetStarterWidgetExtension
//
//  Created by Omkar Nikam on 24/11/25.
//

import WidgetKit
import SwiftUI

@main
struct TodoWidgetStarterWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        TodoWidgetStarterWidgetExtension()
        TodoCountLockWidget()
        TodoWidgetStarterWidgetExtensionControl()
        TodoWidgetStarterWidgetExtensionLiveActivity()
    }
}
