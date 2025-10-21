//
//  HostEventDetailView.swift
//  Mingle
//

import SwiftUI

struct HostEventDetailView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.dismiss) var dismiss
    
    @State private var showingShareSheet = false
    @State private var showingDeleteConfirm = false
    @State private var weather: String? = nil
    
    let event: EventItem
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                eventInfoCard
                descriptionSection
                rsvpSection
                accessRequestSection   // ✅ updated with inline buttons
                shareButton
                deleteButton
            }
            .padding()
        }
        .background(gradientBackground)
        .sheet(isPresented: $showingShareSheet) {
            ActivityView(activityItems: [shareMessage()])
        }
        .confirmationDialog("Are you sure you want to delete this event?",
                            isPresented: $showingDeleteConfirm,
                            titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                store.deleteEvent(eventID: event.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { loadWeather() }
    }
}

// MARK: - Sections
extension HostEventDetailView {
    
    private var headerSection: some View {
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
    }
    
    private var eventInfoCard: some View {
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
        .cornerRadius(16)
        .shadow(radius: 3)
    }
    
    private var descriptionSection: some View {
        Group {
            if let desc = event.description, !desc.isEmpty {
                Text(desc)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(16)
                    .shadow(radius: 3)
            }
        }
    }
    
    private var rsvpSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("RSVPs")
                .font(.headline)
                .foregroundColor(.white)
            
            if event.rsvps.isEmpty {
                Text("No RSVPs yet")
                    .foregroundColor(.white.opacity(0.7))
            } else {
                let totalGuests = event.rsvps.map { $0.partySize }.reduce(0, +)
                let goingCount = event.rsvps.filter { $0.status == .going }.map { $0.partySize }.reduce(0, +)
                let maybeCount = event.rsvps.filter { $0.status == .maybe }.map { $0.partySize }.reduce(0, +)
                let notGoingCount = event.rsvps.filter { $0.status == .notGoing }.map { $0.partySize }.reduce(0, +)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Attending: \(totalGuests)")
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                    
                    HStack {
                        Text("✅ Going: \(goingCount)").foregroundColor(.green)
                        Spacer()
                        Text("🤔 Maybe: \(maybeCount)").foregroundColor(.orange)
                        Spacer()
                        Text("❌ Not Going: \(notGoingCount)").foregroundColor(.red)
                    }
                    .font(.footnote)
                }
                
                Divider().background(Color.white.opacity(0.3))
                
                ForEach(event.rsvps) { rsvp in
                    VStack(alignment: .leading, spacing: 4) {
                        if let name = rsvp.name {
                            Text("👤 \(name)").font(.headline).foregroundColor(.white)
                        }
                        if let age = rsvp.age {
                            Text("🎂 Age: \(age)").font(.subheadline).foregroundColor(.white.opacity(0.8))
                        }
                        Text("📧 \(rsvp.email)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        Text("👥 Party Size: \(rsvp.partySize)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        Text("📌 Status: \(rsvp.status.rawValue.capitalized)")
                            .font(.subheadline.bold())
                            .foregroundColor(rsvp.status == .going ? .green :
                                             rsvp.status == .maybe ? .orange : .red)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(16)
        .shadow(radius: 3)
    }
    
    private var accessRequestSection: some View {
        Group {
            if !event.isPublic {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Access Requests")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if event.accessRequests.isEmpty {
                        Text("No requests yet")
                            .foregroundColor(.white.opacity(0.7))
                    } else {
                        ForEach(event.accessRequests) { request in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(request.email)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text(request.status.rawValue.capitalized)
                                        .foregroundColor(request.status == .approved ? .green :
                                                         request.status == .denied ? .red : .orange)
                                }
                                
                                // ✅ Inline Approve/Deny buttons
                                if request.status == .pending {
                                    HStack {
                                        Button(action: {
                                            store.approveRequest(eventID: event.id, requestID: request.id)
                                        }) {
                                            Text("Approve")
                                                .font(.subheadline.bold())
                                                .foregroundColor(.white)
                                                .padding(6)
                                                .background(Color.green)
                                                .cornerRadius(8)
                                        }
                                        
                                        Button(action: {
                                            store.denyRequest(eventID: event.id, requestID: request.id)
                                        }) {
                                            Text("Deny")
                                                .font(.subheadline.bold())
                                                .foregroundColor(.white)
                                                .padding(6)
                                                .background(Color.red)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(16)
                .shadow(radius: 3)
            }
        }
    }
    
    private var shareButton: some View {
        PrimaryButton(title: "Share Event Details") {
            showingShareSheet = true
        }
        .padding(.top, 10)
    }
    
    private var deleteButton: some View {
        Button(role: .destructive) {
            showingDeleteConfirm = true
        } label: {
            Text("🗑 Delete Event")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.85))
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 3)
        }
        .padding(.top, 10)
    }
    
    private var gradientBackground: some View {
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
    }
}

// MARK: - Helpers
extension HostEventDetailView {
    private func shareMessage() -> String {
        var msg = "🎉 Event: \(event.title)\n📍 City: \(event.city)\n📅 Date: \(event.date.formatted(date: .abbreviated, time: .omitted))"
        if let desc = event.description {
            msg += "\nℹ️ \(desc)"
        }
        return msg
    }
    
    private func loadWeather() {
        Task {
            self.weather = await WeatherAPI.fetchWeather(latitude: 34.05, longitude: -118.25)
        }
    }
}
