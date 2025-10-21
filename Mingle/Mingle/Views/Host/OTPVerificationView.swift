//
//  OTPVerificationView.swift
//  Mingle
//
//  Created by Tanmay on 10/13/25.
//
//

import SwiftUI

struct OTPVerificationView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss
    
    let email: String
    let userData: (name: String, username: String, password: String, age: Int)
    
    @State private var otpCode = ""
    @State private var errorMessage: String?
    @State private var isVerifying = false
    @State private var goToTabs = false
    @State private var resendTimer = 60
    @State private var canResend = false
    
    let otpService = OTPService.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Spacer(minLength: 60)
                
                // MARK: - Icon
                Image(systemName: "envelope.badge.shield.half.filled")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                // MARK: - Title
                Text("Verify Your Email")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // MARK: - Subtitle
                Text("We've sent a 6-digit code to")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(email)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                // MARK: - OTP Input
                OTPInputField(text: $otpCode)
                    .padding(.horizontal, 32)
                
                // MARK: - Error Message
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                // MARK: - Verify Button
                Button(action: verifyOTP) {
                    if isVerifying {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("VERIFY")
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
                .disabled(otpCode.count != 6 || isVerifying)
                .opacity(otpCode.count == 6 && !isVerifying ? 1 : 0.6)
                
                // MARK: - Resend
                if canResend {
                    Button("Resend Code") {
                        resendOTP()
                    }
                    .foregroundColor(.white)
                    .font(.callout.bold())
                } else {
                    Text("Resend code in \(resendTimer)s")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.callout)
                }
                
                Spacer()
                
                // MARK: - Back Button
                Button("Back to Registration") {
                    dismiss()
                }
                .foregroundColor(.white.opacity(0.8))
                .font(.callout)
                .padding(.bottom, 30)
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
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goToTabs) {
                RootTabView().environmentObject(store)
            }
            .onAppear {
                startResendTimer()
            }
        }
    }
    
    // MARK: - Verify OTP
    private func verifyOTP() {
        isVerifying = true
        errorMessage = nil
        
        otpService.verifyOTP(email: email, code: otpCode) { success, error in
            DispatchQueue.main.async {
                isVerifying = false
                
                if success {
                    // Register the user after successful verification
                    if store.registerUser(
                        name: userData.name,
                        username: userData.username,
                        email: email,
                        password: userData.password,
                        age: userData.age
                    ) {
                        goToTabs = true
                    } else {
                        errorMessage = "Registration failed. Please try again."
                    }
                } else {
                    errorMessage = error ?? "Invalid code. Please try again."
                    otpCode = ""
                }
            }
        }
    }
    
    // MARK: - Resend OTP
    private func resendOTP() {
        canResend = false
        resendTimer = 60
        errorMessage = nil
        
        otpService.sendOTP(to: email) { success, error in
            if !success {
                DispatchQueue.main.async {
                    errorMessage = error ?? "Failed to resend code"
                }
            }
        }
        
        startResendTimer()
    }
    
    // MARK: - Timer
    private func startResendTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if resendTimer > 0 {
                resendTimer -= 1
            } else {
                canResend = true
                timer.invalidate()
            }
        }
    }
}

// MARK: - OTP Input Field Component
struct OTPInputField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<6, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 45, height: 55)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        )
                    
                    Text(getDigit(at: index))
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
            }
        }
        .background(
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .frame(width: 1, height: 1)
                .opacity(0.01)
        )
        .onTapGesture {
            isFocused = true
        }
        .onAppear {
            isFocused = true
        }
        .onChange(of: text) { newValue in
            // Limit to 6 digits
            if newValue.count > 6 {
                text = String(newValue.prefix(6))
            }
            // Only allow numbers
            text = newValue.filter { $0.isNumber }
        }
    }
    
    private func getDigit(at index: Int) -> String {
        guard text.count > index else { return "" }
        return String(text[text.index(text.startIndex, offsetBy: index)])
    }
}

#Preview {
    OTPVerificationView(
        email: "test@example.com",
        userData: (name: "Test", username: "test123", password: "pass", age: 25)
    )
    .environmentObject(AppStore())
}
