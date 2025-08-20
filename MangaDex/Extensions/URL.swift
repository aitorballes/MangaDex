
import Foundation

extension URL {
    private static let baseURL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!
        
    static func getMangas(page: Int, limit: Int) -> URL {
        baseURL.appending(path: "/list/mangas")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per", value: String(limit))
            ])
    }
    
    static func getMangasByFilter(page: Int, limit: Int) -> URL {
        baseURL.appending(path: "/search/manga")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per", value: String(limit))
            ])
    }
    
    static func getBestMangas(page: Int, limit: Int) -> URL {
        baseURL.appending(path: "/list/bestMangas")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per", value: String(limit))
            ])
    }
    
    static let getAuthors = baseURL.appending(path: "/list/authors")
    static let getDemographics = baseURL.appending(path: "/list/demographics")
    static let getGenres = baseURL.appending(path: "/list/genres")
    static let getThemes = baseURL.appending(path: "/list/themes")
    
    static let login = baseURL.appending(path: "/users/login")
    static let getSavedMangas = baseURL.appending(path: "/collection/manga")
    
    static func getSavedManga(id: Int) -> URL {
        baseURL.appending(path: "/collection/manga/\(id)")
    }
    
    static let addOrUpdateSavedManga = baseURL.appending(path: "/collection/manga")
    
    static func deleteSavedManga(id: Int) -> URL {
        baseURL.appending(path: "/collection/manga/\(id)")
    }
            
}
