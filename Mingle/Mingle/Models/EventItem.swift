//
//  EventItem.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//
import Foundation
struct EventItem: Identifiable, Codable {
    var id = UUID()
    var hostID: UUID
    var title: String
    var date: Date
    var city: String
    var description: String?
    var isPublic: Bool
    
    // Weather
    var latitude: Double? = nil
    var longitude: Double? = nil
    
    // Related Data
    var rsvps: [GuestRSVP] = []
    var accessRequests: [AccessRequest] = []
    var approvedGuests: [String] = []
}
