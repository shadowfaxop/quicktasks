//
//  TodoWidgetStarterApp.swift
//  TodoWidgetStarter
//
//  Created by Omkar Nikam on 24/11/25.
//

import SwiftUI

@main
struct TodoWidgetStarterApp: App {
    @State private var focusAddField = false

    var body: some Scene {
        WindowGroup {
            MainTodoView()
                .onOpenURL { url in
                    if url.absoluteString == "todoapp://add" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            NotificationCenter.default.post(name: .focusAddField, object: nil)
                        }
                    }
                }

        }
    }
}
