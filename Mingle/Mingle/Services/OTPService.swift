//
//  OTPService.swift
//  Mingle
//
//  Created by csuftitan on 10/13/25.
//
//
//  OTPService.swift
//  Mingle
//
//  Put this file in: Services/
//

import Foundation

class OTPService {
    static let shared = OTPService()
    
    // MARK: - EmailJS Configuration
    private let serviceID = "service_wdojyd2"
    private let templateID = "template_cg1znlq"
    private let publicKey = "6v2b-fkMuypYqYoai"
    
    private var storedOTPs: [String: String] = [:]  // email: otp
    
    private init() {}
    
    // MARK: - Generate OTP
    private func generateOTP() -> String {
        return String(format: "%06d", Int.random(in: 0...999999))
    }
    
    // MARK: - Send OTP via EmailJS
    func sendOTP(to email: String, completion: @escaping (Bool, String?) -> Void) {
        let otp = generateOTP()
        storedOTPs[email] = otp
        
        print("🔐 Generated OTP: \(otp) for email: \(email)")
        
        let url = URL(string: "https://api.emailjs.com/api/v1.0/email/send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Match your EmailJS template variable names exactly
        let parameters: [String: Any] = [
            "service_id": serviceID,
            "template_id": templateID,
            "user_id": publicKey,
            "template_params": [
                "email": email,           // This matches {{email}} in template
                "passcode": otp           // This matches {{passcode}} in template
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            let jsonString = String(data: request.httpBody!, encoding: .utf8)
            print("📤 Sending request: \(jsonString ?? "")")
        } catch {
            print("❌ JSON Error: \(error)")
            completion(false, "Failed to create request")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error)")
                completion(false, "Network error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📥 Response status: \(httpResponse.statusCode)")
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("📥 Response body: \(responseString)")
                }
                
                if httpResponse.statusCode == 200 {
                    print("✅ Email sent successfully!")
                    completion(true, nil)
                } else {
                    completion(false, "Failed to send email. Status: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    // MARK: - Verify OTP
    func verifyOTP(email: String, code: String, completion: @escaping (Bool, String?) -> Void) {
        print("🔍 Verifying OTP for \(email)")
        print("🔍 Entered code: \(code)")
        print("🔍 Stored OTP: \(storedOTPs[email] ?? "none")")
        
        guard let storedOTP = storedOTPs[email] else {
            completion(false, "No OTP found for this email")
            return
        }
        
        if storedOTP == code {
            print("✅ OTP verified successfully!")
            storedOTPs.removeValue(forKey: email)  // Clear OTP after successful verification
            completion(true, nil)
        } else {
            print("❌ Invalid OTP code")
            completion(false, "Invalid OTP code")
        }
    }
}
