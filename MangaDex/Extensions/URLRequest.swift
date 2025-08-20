import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
}

extension URLRequest {
    
    static func get(_ url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = HTTPMethod.get.rawValue  
        request.addBasicHeaders()
        return request
    }
    
    static func get(url: URL, token: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addBasicHeaders()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    static func post<T>(url: URL, body: T) throws -> URLRequest where T: Encodable {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addBasicHeaders()

        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
    
    static func post<T>(url: URL, type: T, credentials: CredentialsModel) throws -> URLRequest where T: Encodable {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addBasicHeaders()
        request.setValue("Basic \(credentials.encodedCredentials)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(type)
        return request
    }
    
    static func post<T>(url: URL, body: T, token: String) throws -> URLRequest where T: Encodable {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addBasicHeaders()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }
    
    static func delete(url: URL, token: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.addBasicHeaders()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    mutating func addBasicHeaders() {
        self.timeoutInterval = 25
        self.setValue("application/json", forHTTPHeaderField: "Accept")
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}

