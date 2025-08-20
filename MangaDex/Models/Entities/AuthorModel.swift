import SwiftData
import Foundation

@Model
final class AuthorModel: Identifiable, Hashable, CustomStringConvertible {
    @Attribute(.unique) var id: String
    var firstName: String?
    var lastName: String?
    var role: String?
    
    init(id: String, firstName: String? = nil, lastName: String? = nil, role: String? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
    }
    
    var description: String {
        [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
}



