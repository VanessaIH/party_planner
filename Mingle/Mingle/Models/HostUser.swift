import Foundation

struct AppUser: Identifiable, Codable {
    var id = UUID()
    var name: String
    var username: String
    var email: String
    var password: String
    var age: Int
}
