//
//  AuthView.swift
//  Mingle
//
//
//  AuthView.swift
//  Mingle
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var store: AppStore
    @State private var isRegistering = false
    
    // MARK: - Fields
    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var age = ""
    
    @State private var errorMessage: String?
    @State private var goToTabs = false
    @State private var showOTPVerification = false
    @State private var isSendingOTP = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer(minLength: 60)
                
                // MARK: - App Title
                Text("MINGLE")
                    .font(.system(size: 52, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 6)
                
                // MARK: - Subtitle
                Text(isRegistering ? "Create your account" : "Party . Play . Connect")
                    .font(.title2.bold())
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.bottom, 10)
                
                // MARK: - Input Fields
                VStack(spacing: 16) {
                    if isRegistering {
                        InputField(icon: "person", placeholder: "Full Name", text: $name)
                        InputField(icon: "envelope", placeholder: "Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        InputField(icon: "number", placeholder: "Age", text: $age)
                            .keyboardType(.numberPad)
                    }
                    InputField(icon: "person.circle", placeholder: "Username", text: $username)
                        .textInputAutocapitalization(.never)
                    InputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                }
                .padding(.horizontal, 32)
                
                // MARK: - Error Message
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 4)
                }
                
                // MARK: - Submit Button
                Button(action: handleAuth) {
                    if isSendingOTP {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Sending...")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        Text(isRegistering ? "REGISTER" : "LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.pink, Color.orange]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(radius: 4)
                .padding(.horizontal, 32)
                .padding(.top, 10)
                .disabled(isSendingOTP)
                
                // MARK: - Toggle Mode
                Button(isRegistering ? "Already have an account? Login" : "New here? Register") {
                    withAnimation {
                        isRegistering.toggle()
                        errorMessage = nil
                    }
                }
                .foregroundColor(.white)
                .font(.callout)
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.bottom, 50)
            // MARK: - Background
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
            .navigationDestination(isPresented: $goToTabs) {
                RootTabView().environmentObject(store)
            }
            .navigationDestination(isPresented: $showOTPVerification) {
                OTPVerificationView(
                    email: email,
                    userData: (name: name, username: username, password: password, age: Int(age) ?? 0)
                )
                .environmentObject(store)
            }
        }
    }
    
    // MARK: - Auth Logic
    private func handleAuth() {
        errorMessage = nil
        
        if isRegistering {
            // Validate fields
            guard !name.isEmpty, !email.isEmpty, !username.isEmpty, !password.isEmpty, let ageInt = Int(age) else {
                errorMessage = "Please fill all fields correctly."
                return
            }
            
            // Validate email format
            guard isValidEmail(email) else {
                errorMessage = "Please enter a valid email address."
                return
            }
            
            // Check if user already exists
            if store.users.contains(where: { $0.username == username || $0.email == email }) {
                errorMessage = "⚠️ Username or email already exists."
                return
            }
            
            // Send OTP
            isSendingOTP = true
            OTPService.shared.sendOTP(to: email) { success, error in
                DispatchQueue.main.async {
                    isSendingOTP = false
                    
                    if success {
                        showOTPVerification = true
                    } else {
                        errorMessage = error ?? "Failed to send verification code"
                    }
                }
            }
        } else {
            // Login
            if store.loginUser(username: username, password: password) {
                goToTabs = true
            } else {
                errorMessage = "⚠️ Invalid credentials."
            }
        }
    }
    
    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    AuthView().environmentObject(AppStore())
}
