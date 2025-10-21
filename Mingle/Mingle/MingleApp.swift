//
//  MingleApp.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//

import SwiftUI

@main
struct MingleApp: App {
    @StateObject private var store = AppStore()   // ✅ create store once

    var body: some Scene {
        WindowGroup {
            ContentView()   // 👈 use ContentView as the entry point
                .environmentObject(store)
        }
    }
}
