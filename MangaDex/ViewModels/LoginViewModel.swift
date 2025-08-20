import Foundation
import Observation

@Observable
final class LoginViewModel {
    let loginHandler: LoginInteractor
    let secureStoreHandler: SecureStoreInteractor
    
    init(loginHandler: LoginInteractor = LoginHandler(), secureStoreHandler: SecureStoreInteractor = SecureStoreHandler()) {
        self.loginHandler = loginHandler
        self.secureStoreHandler = secureStoreHandler
    }
    
    var isLoading = false
    var isNotLoggedIn = true
    
    func login(credentials: CredentialsModel) async {
        isLoading = true
        do {
            let token = try await loginHandler.login(credentials: credentials)
            try secureStoreHandler.store(credentials: credentials)
            try secureStoreHandler.store(token: token)
            isNotLoggedIn = false
        } catch {
            isNotLoggedIn = true
            print("Login failed: \(error)")
        }
        isLoading = false
    }
    
    func getStoreCredentials() -> CredentialsModel? {
        do {
            return try secureStoreHandler.retrieveCredentials()
        } catch {
            print("Failed to retrieve credentials: \(error)")
            return nil
        }
    }
    
    func logOut() {
        isLoading = true
        do {
            try secureStoreHandler.deleteToken()
            isNotLoggedIn = true
        } catch {
            print("Logout failed: \(error)")
        }
        isLoading = false
    }
}
