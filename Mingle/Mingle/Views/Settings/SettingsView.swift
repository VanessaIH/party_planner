//
//  SettingsView.swift
//  Mingle
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: AppStore
    @State private var showAbout = false
    @State private var showLegal = false
    @State private var showDeleteConfirm = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    
                    // MARK: - Header
                    VStack(spacing: 6) {
                        Text("MINGLE")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 6)
                        
                        Text("Settings")
                            .font(.title2.bold())
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 50)
                    
                    // MARK: - App Info
                    settingsSection(title: "App Info") {
                        SettingsButton(
                            label: "About App",
                            icon: "info.circle.fill",
                            color: .blue
                        ) {
                            showAbout.toggle()
                        }
                        .sheet(isPresented: $showAbout) {
                            AboutMingleView()
                        }
                        
                        SettingsButton(
                            label: "Legal & Version Info",
                            icon: "doc.text.fill",
                            color: .purple
                        ) {
                            showLegal.toggle()
                        }
                        .sheet(isPresented: $showLegal) {
                            LegalInfoView()
                        }
                    }
                    
                    // MARK: - Account
                    settingsSection(title: "Account") {
                        SettingsButton(
                            label: "Delete Account",
                            icon: "trash.fill",
                            color: .red
                        ) {
                            showDeleteConfirm = true
                        }
                        .confirmationDialog(
                            "Are you sure you want to delete your account? This action cannot be undone.",
                            isPresented: $showDeleteConfirm
                        ) {
                            Button("Delete", role: .destructive) {
                                store.deleteCurrentUser()
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }

                    // MARK: - Footer
                    VStack(spacing: 4) {
                        Text("Mingle v1.0")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))
                        Text("© 2025 Roszhan Raj Meenakshi Sundhresan")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.1, blue: 0.4),
                        Color(red: 0.7, green: 0.5, blue: 0.9)
                    ]),
                    center: .center,
                    startRadius: 30,
                    endRadius: 600
                )
                .ignoresSafeArea()
            )
        }
    }
    
    // MARK: - Reusable Section
    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.9))
                .padding(.leading, 4)
            
            VStack(spacing: 14) {
                content()
            }
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    SettingsView().environmentObject(AppStore())
}

//
// MARK: - Custom Button Component
//
struct SettingsButton: View {
    var label: String
    var icon: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(color)
                    .clipShape(Circle())
                
                Text(label)
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.85))
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

//
// MARK: - About App View
//
struct AboutMingleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("About Mingle")
                    .font(.largeTitle.bold())
                
                Text("""
                Mingle is a student networking app designed to help hosts and guests connect during campus events. It enables event creation, participation, and real-time engagement in a seamless and social environment.

                Our goal is to make every interaction on campus meaningful — whether through study groups, club events, or spontaneous meetups.

                Developed by Roszhan Raj Meenakshi Sundhresan  
                California State University, Fullerton  
                Version 1.0.0
                """)
                .font(.body)
                .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding()
        }
    }
}

//
// MARK: - Legal Info View
//
struct LegalInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Legal Information")
                    .font(.largeTitle.bold())
                
                Text("""
                Version: 1.0.0  
                © 2025 Mingle. All rights reserved.

                Mingle and its associated designs, interfaces, and functionality are the intellectual property of Roszhan Raj Meenakshi Sundhresan.

                Unauthorized copying, modification, or distribution of this application or any part of it is strictly prohibited and may result in legal consequences.

                For inquiries or permissions, please contact the developer.
                """)
                .font(.body)
                .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding()
        }
    }
}
