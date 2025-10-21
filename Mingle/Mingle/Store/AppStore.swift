//
//  AppStore.swift
//  Mingle
//
//  Created by Roszhan Raj on 01/10/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class AppStore: ObservableObject {
    // MARK: - Published State
    @Published var users: [AppUser] = []
    @Published var events: [EventItem] = []
    @Published var currentUserID: UUID? = nil

    // MARK: - Computed
    var currentUser: AppUser? {
        users.first(where: { $0.id == currentUserID })
    }

    // MARK: - Persistence
    private let storageKey = "MingleAppStoreV2"
    
    private struct Snapshot: Codable {
        var users: [AppUser]
        var events: [EventItem]
        var currentUserID: UUID?
    }
    
    init() { load() }
    
    private func save() {
        let snapshot = Snapshot(users: users, events: events, currentUserID: currentUserID)
        if let data = try? JSONEncoder().encode(snapshot) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) else { return }
        self.users = snapshot.users
        self.events = snapshot.events
        self.currentUserID = snapshot.currentUserID
    }

    // MARK: - User Functions
    func registerUser(name: String, username: String, email: String, password: String, age: Int) -> Bool {
        guard !users.contains(where: { $0.email == email || $0.username == username }) else {
            return false
        }
        let user = AppUser(name: name, username: username, email: email, password: password, age: age)
        users.append(user)
        currentUserID = user.id
        save()
        return true
    }

    func loginUser(username: String, password: String) -> Bool {
        if let user = users.first(where: { $0.username == username && $0.password == password }) {
            currentUserID = user.id
            save()
            return true
        }
        return false
    }

    func logoutUser() {
        currentUserID = nil
        save()
    }

    // MARK: - Event Functions
    func createEvent(title: String, date: Date, city: String, description: String?, isPublic: Bool) {
        guard let user = currentUser else { return }
        let event = EventItem(
            hostID: user.id,
            title: title,
            date: date,
            city: city,
            description: description,
            isPublic: isPublic
        )
        events.append(event)
        save()
    }
    
    func deleteEvent(eventID: UUID) {
        events.removeAll(where: { $0.id == eventID })
        save()
    }

    func eventsForCurrentUser() -> [EventItem] {
        guard let user = currentUser else { return [] }
        return events.filter { $0.hostID == user.id }
    }

    // MARK: - RSVP
    func submitRSVP(for eventID: UUID, email: String, name: String, age: Int, partySize: Int, status: RSVPStatus) {
        if let index = events.firstIndex(where: { $0.id == eventID }) {
            let rsvp = GuestRSVP(email: email, name: name, age: age, partySize: partySize, status: status)
            if let existing = events[index].rsvps.firstIndex(where: { $0.email == email }) {
                events[index].rsvps[existing] = rsvp
            } else {
                events[index].rsvps.append(rsvp)
            }
            save()
        }
    }

    func submitAccessRequest(for eventID: UUID, email: String) {
        if let index = events.firstIndex(where: { $0.id == eventID }) {
            if !events[index].accessRequests.contains(where: { $0.email == email }) {
                let request = AccessRequest(email: email, date: Date())
                events[index].accessRequests.append(request)
                save()
            }
        }
    }

    func approveRequest(eventID: UUID, requestID: UUID) {
        if let eventIndex = events.firstIndex(where: { $0.id == eventID }),
           let reqIndex = events[eventIndex].accessRequests.firstIndex(where: { $0.id == requestID }) {
            events[eventIndex].accessRequests[reqIndex].status = .approved
            events[eventIndex].approvedGuests.append(events[eventIndex].accessRequests[reqIndex].email)
            save()
        }
    }

    func denyRequest(eventID: UUID, requestID: UUID) {
        if let eventIndex = events.firstIndex(where: { $0.id == eventID }),
           let reqIndex = events[eventIndex].accessRequests.firstIndex(where: { $0.id == requestID }) {
            events[eventIndex].accessRequests[reqIndex].status = .denied
            save()
        }
    }

    // MARK: - Delete Only Current User
    func deleteCurrentUser() {
        guard let userID = currentUserID else { return }

        // Remove user from list
        users.removeAll { $0.id == userID }

        // Remove all events created by that user
        events.removeAll { $0.hostID == userID }

        // Clear login
        currentUserID = nil

        // Save updated data
        save()
    }

    // MARK: - Reset Everything (Admin Use Only)
    func reset() {
        users.removeAll()
        events.removeAll()
        currentUserID = nil
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
