import Foundation

enum NetworkError: LocalizedError {
    case notHTTPResponse
    case statusCode(Int)
    case decodingError(Error)
    case noToken
    case unknownError(Error)

    var errorDescription: String? {
        switch self {
        case .notHTTPResponse:
            return String(localized: "The response is not an HTTP response.")
        case .statusCode(let code):
            return String(localized: "Received an unexpected status code: \(code).")
        case .decodingError(let error):
            return String(localized: "Decoding error: \(error.localizedDescription)")
        case .noToken:
            return String(localized: "You should be logged in to perform this action.")
        case .unknownError(let error):
            return String(localized: "An unknown error occurred: \(error.localizedDescription)")
        }
    }
}

protocol NetworkInteractor {
    var session: URLSession { get }
}

extension NetworkInteractor {
    func getData<T>(for request: URLRequest, expecting type: T.Type) async throws -> T where T: Codable {

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.notHTTPResponse
            }

            guard httpResponse.statusCode == 200 else {
                throw NetworkError.statusCode(httpResponse.statusCode)
            }
            
            if T.self == String.self, let str = String(data: data, encoding: .utf8) as? T {
                return str
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .customISO8601
                let result = try decoder.decode(T.self, from: data)
               
                return result
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error

        } catch {
            throw NetworkError.unknownError(error)
        }
    }
    
    func performRequest(_ request: URLRequest) async throws {
          do {
              let (_, response) = try await session.data(for: request)
              guard let httpResponse = response as? HTTPURLResponse else {
                  throw NetworkError.notHTTPResponse
              }
              guard (200..<300).contains(httpResponse.statusCode) else {
                  throw NetworkError.statusCode(httpResponse.statusCode)
              }
          } catch let error as NetworkError {
              throw error
          } catch {
              throw NetworkError.unknownError(error)
          }
      }
}

extension Formatter {
    static let iso8601withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601withFractionalSeconds.date(from: string) ?? Formatter.iso8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

