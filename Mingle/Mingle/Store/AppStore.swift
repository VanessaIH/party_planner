//
//  AppStore.swift
//  Mingle
//
//  Created by Roszhan Raj on 01/10/25.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation

@MainActor
class AppStore: ObservableObject {
    // MARK: - Published State
    @Published var users: [AppUser] = []
    @Published var events: [EventItem] = []
    @Published var currentUserID: UUID? = nil

    //Search+Filter
    @Published var searchText: String = ""
    @Published var maxDistance: Double = 20
    @Published var userCoordinates: CLLocationCoordinate2D? = nil
    
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

    func captureUserLocation(_ coord: CLLocationCoordinate2D) {
            userCoordinates = coord
            if let id = currentUserID, let idx = users.firstIndex(where: { $0.id == id }) {
                users[idx].lastLatitude = coord.latitude
                users[idx].lastLongitude = coord.longitude
                save()
            }
        }
    
    // MARK: - Event Functions
    func createEvent(title: String, date: Date, city: String, fullAddress: String?, description: String?, isPublic: Bool, latitude: Double? = nil, longitude: Double? = nil) {
        guard let user = currentUser else { return }
        var event = EventItem(
            hostID: user.id,
            title: title,
            date: date,
            city: city,
            description: description,
            isPublic: isPublic
        )
        event.fullAddress = fullAddress
        event.latitude = latitude
        event.longitude = longitude
        event.approvedGuests.append(user.email)
        events.append(event)
        save()
    }
    
    //when edited will update event
    func updateEvent(_ updated: EventItem) {
        guard let ind = events.firstIndex(where: { $0.id == updated.id}) else {return}
        events[ind] = updated
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

    // MARK: - RSVP&Access
    func submitRSVP(for eventID: UUID,
                        email: String,
                        name: String,
                        age: Int,
                        partySize: Int,
                        status: RSVPStatus) {
            guard let index = events.firstIndex(where: { $0.id == eventID }),
                  let current = currentUser else { return }

            // Prevent host from RSVPing to their own event
            if events[index].hostID == current.id { return }

            let rsvp = GuestRSVP(email: email, name: name, age: age, partySize: partySize, status: status)
            if let existing = events[index].rsvps.firstIndex(where: { $0.email == email }) {
                events[index].rsvps[existing] = rsvp
            } else {
                events[index].rsvps.append(rsvp)
            }
            save()
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

    // MARK: - Search & Distance Filter
    func filteredEvents() -> [EventItem] {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        var effectiveUserCoord: CLLocationCoordinate2D? = nil
        if let live = userCoordinates {
            effectiveUserCoord = live
        } else if let u = currentUser, let lat = u.lastLatitude, let long = u.lastLongitude {
            effectiveUserCoord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        return events.filter { event in
            // 1. Text Match
            let haystack = [
                event.title,
                event.city,
                event.fullAddress ?? "",
                users.first(where: { $0.id == event.hostID })?.name ?? ""
            ].joined(separator: " ").lowercased()

            let matchesSearch = text.isEmpty || haystack.contains(text)

            // 2. Distance Match
            let withinDistance: Bool = {
                guard let userCoord = effectiveUserCoord else { return true }
                guard let d = event.distanceMiles(from: userCoord) else { return false }
                return d <= maxDistance
            }()

            return matchesSearch && withinDistance
        }
        .sorted { $0.date < $1.date}
    }
    
    

    // MARK: - Delete Only Current User
    func deleteCurrentUser() {
        guard let userID = currentUserID else { return }

        users.removeAll { $0.id == userID }
        events.removeAll { $0.hostID == userID }
        currentUserID = nil
        save()
    }

    // MARK: - Reset (Admin)
    func reset() {
        users.removeAll()
        events.removeAll()
        currentUserID = nil
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
