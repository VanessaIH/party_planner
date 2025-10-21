//
//  LogoutView.swift
//  Mingle
//

import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var store: AppStore
    @State private var isLoggedOut = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background
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
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // MARK: - Title
                    Text("Logout")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                    
                    Text("Are you sure you want to logout?")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    // MARK: - Logout Button
                    Button(action: {
                        store.logoutUser()
                        isLoggedOut = true
                    }) {
                        Text("LOGOUT")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.9))
                            .cornerRadius(20)
                            .shadow(radius: 3)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                }
                .navigationDestination(isPresented: $isLoggedOut) {
                    AuthView().environmentObject(store)
                }
            }
        }
    }
}

#Preview {
    LogoutView().environmentObject(AppStore())
}
