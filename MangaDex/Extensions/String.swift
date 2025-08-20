import Foundation

extension String {
    func cleanedURL() -> URL? {
        let cleanedString = self.replacingOccurrences(of: "\"", with: "")
        return URL(string: cleanedString)
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
    public var description: String { self }
}
