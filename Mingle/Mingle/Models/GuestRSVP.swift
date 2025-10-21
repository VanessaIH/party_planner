//
//  GuestRSVP.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//
import Foundation

struct GuestRSVP: Identifiable, Codable {
    var id = UUID()
    var email: String
    var name: String?
    var age: Int?
    var partySize: Int
    var status: RSVPStatus
}
