//
//  EventItem.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//
import Foundation
import CoreLocation

struct EventItem: Identifiable, Codable {
    var id = UUID()
    var hostID: UUID
    
    var title: String
    var date: Date
    var city: String
    var description: String?
    var isPublic: Bool
    
    var fullAddress: String? = nil
    
    // Weather/location
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    // Related Data
    var rsvps: [GuestRSVP] = []
    var accessRequests: [AccessRequest] = []
    var approvedGuests: [String] = []
    
    func isHost(currentUserID: UUID) -> Bool {
        hostID == currentUserID
    }
    func isApproved(userIdString: String?, userUUID: UUID? = nil) -> Bool {
            if let s = userIdString, approvedGuests.contains(s) { return true }
            if let u = userUUID, u == hostID { return true } // host always "approved"
            return false
        }

    //if approve/host full address else city
    func displayAddress(forUserIdString s: String?, userUUID: UUID? = nil) -> String {
        if isApproved(userIdString: s, userUUID: userUUID),
            let addr = fullAddress, !addr.isEmpty {
            return addr + ", " + city
        } else {
            return city
        }
    }

    func distanceMiles(from coord: CLLocationCoordinate2D?) -> Double? {
        guard let lat = latitude, let lon = longitude, let c = coord else { return nil }
        let eventLoc = CLLocation(latitude: lat, longitude: lon)
        let me = CLLocation(latitude: c.latitude, longitude: c.longitude)
        return eventLoc.distance(from: me) / 1609.344
    }
}
