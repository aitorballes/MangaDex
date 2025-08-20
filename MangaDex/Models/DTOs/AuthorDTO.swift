struct AuthorDTO: Identifiable, Codable, CustomStringConvertible, Hashable {
    let id: String
    let firstName: String?
    let lastName: String?
    let role: String?
    
    var description: String {
        [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
}

extension AuthorDTO {
    func toModel() -> AuthorModel {
        return .init(
            id: id,
            firstName: firstName,
            lastName: lastName,
            role: role
        )
    }
}


