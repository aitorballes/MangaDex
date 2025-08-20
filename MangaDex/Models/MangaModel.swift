import Foundation

struct MangaModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let background: String?
    let sypnosis: String?
    let score: Double?
    let volumes: Int?
    let picture: URL?
    let startDate: Date?
    let endDate: Date?
    let authors: [AuthorDTO]
    let genres: [String]
    let demographics: [String]
    let themes: [String]
    let url: URL?
    
    var fullDate: String? {
        var date = ""
        if let startDate {
            date.append(startDate.formatted(date: .numeric, time: .omitted))
        }
        
        if let endDate {
            date.append(" - ")
            date.append(endDate.formatted(date: .numeric, time: .omitted))
        }
        
        return date.isEmpty ? nil : date
    }
    
    var authorList: String {
        authors.map { $0.description }.joined(separator: ", ")
    }
    
}
