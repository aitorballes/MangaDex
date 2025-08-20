import Foundation

enum KeychainError: LocalizedError {
    case unexpectedData
    case unhandledError(status: OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .unexpectedData:
            return String(localized: "Unexpected data format encountered while accessing the keychain.")
        case .unhandledError(let status):
            return String(localized: "An unhandled error occurred while accessing the keychain: \(status).")
        }
    }
}

protocol SecureStoreInteractor {
    var secureStoreServer: String { get }
    
    func store(credentials: CredentialsModel) throws(KeychainError)
    func retrieveCredentials() throws(KeychainError) -> CredentialsModel?
    func store(token: String) throws(KeychainError)
    func retrieveToken() throws(KeychainError) -> String?
    func deleteToken() throws(KeychainError)
}

struct SecureStoreHandler: SecureStoreInteractor {
    var secureStoreServer = "mangadex.keychain"
    private let secureStoreAccount = "user.logged"

    func store(credentials: CredentialsModel) throws(KeychainError) {
        let account = credentials.email
        let password = credentials.password.data(using: .utf8)!
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: account,
            kSecAttrServer as String: secureStoreServer
        ]
        
        SecItemDelete(baseQuery as CFDictionary)

        var addQuery = baseQuery
        addQuery[kSecValueData as String] = password

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func retrieveCredentials() throws(KeychainError) -> CredentialsModel? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: secureStoreServer,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound  else { return nil }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        guard let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8),
              let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedData
        }

        return CredentialsModel(email: account, password: password)
    }

    func store(token: String) throws(KeychainError) {
        let password = token.data(using: .utf8)!
        let baseQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: secureStoreAccount
        ]
        
        SecItemDelete(baseQuery as CFDictionary)
        
        var addQuery = baseQuery
        addQuery[kSecValueData as String] = password
        
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func retrieveToken() throws(KeychainError) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound  else { return nil }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8)
        else {
            throw KeychainError.unexpectedData
        }

        return token
    }

    func deleteToken() throws(KeychainError) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: secureStoreAccount,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
