import Foundation

struct MangaItemDTO: Codable {
    let demographics: [DemographicDTO]
    let authors: [AuthorDTO]
    let background: String?
    let sypnosis: String?
    let startDate: Date?
    let id: Int
    let themes: [ThemeDTO]
    let url: String?
    let volumes: Int?
    let titleJapanese: String?
    let endDate: Date?
    let title: String
    let chapters: Int?
    let status: String?
    let score: Double?
    let mainPicture: String
    let genres: [GenreDTO]
    let titleEnglish: String?
}

extension MangaItemDTO {
    func toModel() -> MangaModel {
        return .init(
            id: id,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese,
            background: background,
            sypnosis: sypnosis,            
            score: score,
            volumes: volumes,
            picture: mainPicture.cleanedURL(),
            startDate: startDate,
            endDate: endDate,
            authors: authors,
            genres: genres.map { $0.genre },
            demographics: demographics.map { $0.demographic },
            themes: themes.map { $0.theme },
            url: url?.cleanedURL()
        )
    }
}








