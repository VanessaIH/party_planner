//
//  GuestIntroView.swift
//  Mingle
//

import SwiftUI

struct GuestIntroView: View {
    @EnvironmentObject var store: AppStore
    @State private var name = ""
    @State private var age = ""
    @State private var email = ""
    
    @State private var errorMessage: String?
    @State private var isSaved = false

    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - App Title
                Text("MINGLE")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .padding(.top, 60)
                
                // MARK: - Subtitle
                Text("Guest Info")
                    .font(.title2.bold())
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 30)
                
                Spacer(minLength: 20)
                
                // MARK: - Input Fields
                VStack(spacing: 16) {
                    InputField(icon: "person", placeholder: "Full Name", text: $name)
                    InputField(icon: "number", placeholder: "Age", text: $age)
                        .keyboardType(.numberPad)
                    InputField(icon: "envelope", placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                }
                .padding(.horizontal, 32)
                
                // MARK: - Error Message
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 8)
                }
                
                // MARK: - Continue Button
                Button(action: {
                    if let ageInt = Int(age), !name.isEmpty, !email.isEmpty {
                        updateUserInfo(name: name, age: ageInt, email: email)
                        isSaved = true
                    } else {
                        errorMessage = "⚠️ Please fill all fields correctly."
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.pink, Color.orange]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.bottom, 50)
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.1, blue: 0.4),
                        Color(red: 0.7, green: 0.5, blue: 0.9)
                    ]),
                    center: .center,
                    startRadius: 30,
                    endRadius: 500
                )
                .ignoresSafeArea()
            )
            .navigationDestination(isPresented: $isSaved) {
                DiscoverView().environmentObject(store)
            }
        }
    }
    
    // MARK: - Helper Function
    private func updateUserInfo(name: String, age: Int, email: String) {
        guard let currentUserID = store.currentUserID,
              let index = store.users.firstIndex(where: { $0.id == currentUserID }) else { return }
        
        store.users[index].name = name
        store.users[index].age = age
        store.users[index].email = email
    }
}

#Preview {
    GuestIntroView().environmentObject(AppStore())
}
