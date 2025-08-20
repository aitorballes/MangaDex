protocol DataRepository {
    var secureStoreHandler: SecureStoreInteractor { get }
    
    func getMangas(page: Int) async throws -> MangasPagedModel
    func getMangasByFilters(page: Int, filters: FiltersModel) async throws -> MangasPagedModel
    func getBestMangas(page: Int) async throws -> MangasPagedModel
    func getAuthors() async throws -> [AuthorDTO]
    func getDemographics() async throws -> [String]
    func getGenres() async throws -> [String]
    func getThemes() async throws -> [String]
    func getSavedMangas() async throws -> [SavedMangaModel]
    func getSavedManga(id: Int) async throws -> SavedMangaModel?
    func addOrUpdateSavedManga(manga: MangaModel, volumesOwned: [Int], volumesRead: Int) async throws
    func deleteSavedManga(id: Int) async throws

}

extension DataRepository {
    func getMangas() async throws -> MangasPagedModel {
        try await getMangas(page: 1)
    }
    
    func getMangasByFilters(filters: FiltersModel) async throws -> MangasPagedModel {
        try await getMangasByFilters(page: 1, filters: filters)
    }
    
    func getBestMangas() async throws -> MangasPagedModel {
        try await getBestMangas(page: 1)
    }
}


