import Foundation

protocol LoginInteractor {
    var secureStoreHandler: SecureStoreInteractor { get }
    
    func login(credentials: CredentialsModel) async throws -> String
}

struct LoginHandler: LoginInteractor, NetworkInteractor {
    var session: URLSession = .shared
    let secureStoreHandler: SecureStoreInteractor = SecureStoreHandler()
    
    func login(credentials: CredentialsModel) async throws -> String {
        try await getData(for: .post(url: .login, type: credentials, credentials: credentials), expecting: String.self)
    }
}

        
