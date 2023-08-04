//
//  Bubble_LevelApp.swift
//  Bubble Level
//
//  Created by Gabriel Marquez on 2023-08-03.
//

import SwiftUI

@main
struct Bubble_LevelApp: App {
    @StateObject private var motionDetector = MotionDetector(updateInterval: 0.01)

    var body: some Scene {
        WindowGroup {
            LevelView()
                .environmentObject(motionDetector)
        }
    }
}
