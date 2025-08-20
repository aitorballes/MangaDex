import Foundation

struct SavedMangaResponseDTO: Codable {
    let manga: MangaItemDTO
    let completeCollection: Bool
    let id: String
    let user: UserDTO
    let readingVolume: Int
    let volumesOwned: [Int]
}

struct UserDTO: Codable {
    let id: String
}

extension SavedMangaResponseDTO {
    func toModel() -> SavedMangaModel {
        return SavedMangaModel(
            manga: manga.toModel(),
            completeCollection: completeCollection,
            readingVolume: readingVolume,
            volumesOwned: volumesOwned
        )
    }
}




