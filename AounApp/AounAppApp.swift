//
//  AounAppApp.swift
//  AounApp
//
//  Created by Nada Abdullah on 20/06/1446 AH.
//

import SwiftUI

@main
struct AounAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: TaskFile.self) // ربط SwiftData مع النموذج
            }
    }
}
