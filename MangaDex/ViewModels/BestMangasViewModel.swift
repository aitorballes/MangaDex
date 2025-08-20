import Foundation
import Observation

@Observable
final class BestMangasViewModel {
    let repository: DataRepository

    init(repository: DataRepository = NetworkRepository()) {
        self.repository = repository
    }
    
    var bestMangas: [MangaModel] = []
    var currentPage = 0
    var isLoading = false
    
    func getBestMangas() async {
        isLoading = true
        do {
            let pagedModel = try await repository.getBestMangas()
            bestMangas = pagedModel.mangas
            currentPage = pagedModel.currentPage
        } catch {
            print("Error getting best mangas: \(error.localizedDescription)")
        }
        isLoading = false            
    }
    
    func getNextMangas() async {
        isLoading = true
        do {
            let nextPage = currentPage + 1
            let pagedModel = try await repository.getBestMangas(page: nextPage)
            bestMangas.append(contentsOf: pagedModel.mangas)
            currentPage = pagedModel.currentPage
        } catch {
            print("Failed to fetch mangas for page \(currentPage): \(error)")
        }
        isLoading = false
    }
}
