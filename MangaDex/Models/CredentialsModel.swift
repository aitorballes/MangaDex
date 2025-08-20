import Foundation

struct CredentialsModel: Codable {
    let email: String
    let password: String
    
    var encodedCredentials: String {
        let loginString = "\(email):\(password)"
        let loginData = loginString.data(using: .utf8)!
        return loginData.base64EncodedString()
    }
}
