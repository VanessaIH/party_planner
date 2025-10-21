//
//  GuestEventDetailView.swift
//  Mingle
//

import SwiftUI

struct GuestEventDetailView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss
    
    @State private var partySize = 1
    @State private var status: RSVPStatus = .going
    @State private var emailInput = ""
    @State private var weather: String? = nil
    
    var event: EventItem
    
    // MARK: - Current Logged-in User
    private var currentUser: AppUser? {
        guard let id = store.currentUserID else { return nil }
        return store.users.first(where: { $0.id == id })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: Header
                VStack(spacing: 6) {
                    Text("MINGLE")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                    
                    Text("Event Details")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.top, 20)
                
                // MARK: Event Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Text(event.date.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("📍 \(event.city)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    if let weather = weather {
                        Text("🌤 Forecast: \(weather)")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    Text(event.isPublic ? "Public Event" : "Private Event")
                        .font(.headline)
                        .foregroundColor(event.isPublic ? .green : .red)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // MARK: Description
                if let desc = event.description, !desc.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About This Event")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(desc)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                
                // MARK: RSVP or Request Access
                if event.isPublic || (currentUser != nil && event.approvedGuests.contains(currentUser!.email)) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("RSVP to this Event")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Stepper("👥 Party Size: \(partySize)", value: $partySize, in: 1...10)
                            .foregroundColor(.white)
                        
                        Picker("Status", selection: $status) {
                            ForEach(RSVPStatus.allCases, id: \.self) { s in
                                Text(s.rawValue.capitalized).tag(s)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        PrimaryButton(title: "Submit RSVP") {
                            if let user = currentUser {
                                store.submitRSVP(
                                    for: event.id,
                                    email: user.email,
                                    name: user.name,
                                    age: user.age ?? 0,
                                    partySize: partySize,
                                    status: status
                                )
                                dismiss()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Request Access to this Private Event")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        InputField(icon: "envelope", placeholder: "Enter your email", text: $emailInput)
                        
                        PrimaryButton(title: "Request Access") {
                            if !emailInput.isEmpty {
                                store.submitAccessRequest(for: event.id, email: emailInput)
                                dismiss()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.12))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
            }
            .padding()
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
        .onAppear { loadWeather() }
    }
    
    private func loadWeather() {
        Task {
            self.weather = await WeatherAPI.fetchWeather(latitude: 40.71, longitude: -74.00)
        }
    }
}

#Preview {
    let sample = EventItem(
        hostID: UUID(),
        title: "Sample Party",
        date: Date(),
        city: "New York",
        description: "Fun night with music! 🎶",
        isPublic: true
    )
    return NavigationStack {
        GuestEventDetailView(event: sample).environmentObject(AppStore())
    }
}
