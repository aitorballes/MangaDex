import Foundation

struct NetworkRepository: DataRepository, NetworkInteractor {
    
    private let maxItems = 20
    
    var session: URLSession = .shared
    var secureStoreHandler: SecureStoreInteractor = SecureStoreHandler()
    
    func getMangas(page: Int) async throws -> MangasPagedModel {
        try await getData(for: .get(.getMangas(page: page, limit: maxItems)), expecting: MangaResponseDTO.self).toModel()
    }
    
    func getMangasByFilters(page: Int, filters: FiltersModel) async throws -> MangasPagedModel {
        let url = URL.getMangasByFilter(page: page, limit: maxItems)
        let request = try URLRequest.post(url: url, body: filters)
        let responseDTO = try await getData(for: request, expecting: MangaResponseDTO.self)
        return responseDTO.toModel()
    }
    
    func getBestMangas(page: Int) async throws -> MangasPagedModel {
        try await getData(for: .get(.getBestMangas(page: page, limit: maxItems)), expecting: MangaResponseDTO.self).toModel()
    }
    
    func getSavedMangas() async throws -> [SavedMangaModel] {
        do {
            if let token = try secureStoreHandler.retrieveToken() {
                let responseDTO = try await getData(for: .get(url: .getSavedMangas, token: token), expecting: [SavedMangaResponseDTO].self)
                return responseDTO.map { $0.toModel() }
            } else {
                throw NetworkError.noToken
            }
           
        } catch {
            print("Error retrieving saved mangas: \(error)")
            return []
        }
    }
    
    func getSavedManga(id: Int) async throws -> SavedMangaModel? {
        do {
            if let token = try secureStoreHandler.retrieveToken() {
                let responseDTO = try await getData(for: .get(url: .getSavedManga(id: id), token: token), expecting: SavedMangaResponseDTO?.self)
                guard let responseDTO = responseDTO else {
                    return nil
                }
                return responseDTO.toModel()
            } else {
                throw NetworkError.noToken
            }
           
        } catch {
            print("Error retrieving saved mangas: \(error)")
            return nil
        }
    }
    
    func addOrUpdateSavedManga(manga: MangaModel, volumesOwned: [Int], volumesRead: Int) async throws {
        do {
            if let token = try secureStoreHandler.retrieveToken() {
                let dto = SavedMangaDTO(manga: manga, volumesOwned: volumesOwned, volumesRead: volumesRead)
                let request = try URLRequest.post(url: .addOrUpdateSavedManga, body: dto, token: token)
                try await performRequest(request)
            } else {
                throw NetworkError.noToken
            }
           
        } catch {
            print("Error adding or updating saved manga: \(error)")
        }
    }
    
    func deleteSavedManga(id: Int) async throws {
        do {
            if let token = try secureStoreHandler.retrieveToken() {
               
                let request = URLRequest.delete(url: .deleteSavedManga(id: id), token: token)
                try await performRequest(request)
            } else {
                throw NetworkError.noToken
            }
            
        } catch {
            print("Error adding or updating saved manga: \(error)")
        }
        
    }
    func getAuthors() async throws -> [AuthorDTO] {
        try await getData(for: .get(.getAuthors), expecting: [AuthorDTO].self)
    }
    
    func getDemographics() async throws -> [String] {
        try await getData(for: .get(.getDemographics), expecting: [String].self)
    }
    
    func getGenres() async throws -> [String] {
        try await getData(for: .get(.getGenres), expecting: [String].self)
    }
    
    func getThemes() async throws -> [String] {
        try await getData(for: .get(.getThemes), expecting: [String].self)
    }
    
}
