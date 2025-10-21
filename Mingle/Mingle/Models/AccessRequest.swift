//
//  AccessRequest.swift
//  Mingle
//
//  Created by ROSZHAN RAJ on 01/10/25.
//
import Foundation
enum AccessStatus: String, Codable {
    case pending, approved, denied
}

struct AccessRequest: Identifiable, Codable {
    var id = UUID()
    var email: String
    var date: Date
    var status: AccessStatus = .pending
}
