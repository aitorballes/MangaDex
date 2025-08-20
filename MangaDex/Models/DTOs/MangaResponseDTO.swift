struct MangaResponseDTO: Codable {
    let metadata: MetadataDTO
    let items: [MangaItemDTO]
}

extension MangaResponseDTO {
    func toModel() -> MangasPagedModel {
        return .init(
            mangas: items.map { $0.toModel() },
            currentPage: metadata.page
        )
    }
}
    
