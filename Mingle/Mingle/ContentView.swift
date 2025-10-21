//
//  ContentView.swift
//  Mingle
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        Group {
            if store.currentUserID != nil {
                // Logged-in user → show main app tabs
                RootTabView()
                    .environmentObject(store)
            } else {
                // Not logged in → show authentication
                AuthView()
                    .environmentObject(store)
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AppStore())
}
