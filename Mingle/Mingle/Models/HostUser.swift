import Foundation
import CoreLocation

struct AppUser: Identifiable, Codable {
    var id = UUID()
    var name: String
    var username: String
    var email: String
    var password: String
    var age: Int?
    
    var lastLatitude: Double? = nil
    var lastLongitude: Double? = nil
}

extension AppUser {
    var coordinates: CLLocationCoordinate2D? {
        guard let lastLat = lastLatitude, let lastLong = lastLongitude else { return nil }
        return CLLocationCoordinate2D(latitude: lastLat, longitude: lastLong)
    }
}
