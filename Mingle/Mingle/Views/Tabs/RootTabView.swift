////
////  RootTabView.swift
////  Mingle
////
//
//import SwiftUI
//
//struct RootTabView: View {
//    @EnvironmentObject var store: AppStore
//
//    var body: some View {
//        TabView {
//            // Host Tabs
//            if store.isHostLoggedIn {
//                HostHomeView()
//                    .tabItem {
//                        Label("Host", systemImage: "person.crop.square")
//                    }
//            }
//
//            // Guest Tabs
//            if store.isGuestLoggedIn {
//                DiscoverView()
//                    .tabItem {
//                        Label("Guest", systemImage: "party.popper")
//                    }
//            }
//
//            // Settings Tab (shared)
//            SettingsView()
//                .tabItem {
//                    Label("Settings", systemImage: "gearshape")
//                }
//
//            // Logout Tab (shared)
//            LogoutView()
//                .tabItem {
//                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
//                }
//        }
//    }
//}
//
//#Preview {
//    RootTabView().environmentObject(AppStore())
//}

//
//  RootTabView.swift
//  Mingle
//

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        TabView {
            // Host Tab
            HostHomeView()
                .tabItem {
                    Label("Host", systemImage: "plus.square.on.square")
                }

            // Guest Tab
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "party.popper")
                }

            // Settings
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }

            // Logout
            LogoutView()
                .tabItem {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                }
        }
    }
}

#Preview {
    RootTabView().environmentObject(AppStore())
}
