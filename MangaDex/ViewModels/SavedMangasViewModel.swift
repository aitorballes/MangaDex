import Foundation
import Observation

@Observable
final class SavedMangasViewModel {
    let repository: DataRepository
    let secureStoreHandler: SecureStoreInteractor
    
    init(repository: DataRepository = NetworkRepository(), secureStoreHandler: SecureStoreInteractor = SecureStoreHandler()) {
        self.repository = repository
        self.secureStoreHandler = secureStoreHandler
    }
    
    var savedMangas: [SavedMangaModel] = []
    var currentReadingVolumes: Int = 0
    var currentOwnedVolumes: Set<Int> = []
    var isSavedManga: Bool = false
    
    var isLoading = false
    
    func getSavedMangas() async {
        isLoading = true
        do {
            savedMangas =  try await repository.getSavedMangas()
        } catch {
            print("Failed to retrieve saved mangas: \(error)")
        }
        isLoading = false
    }
    
    func getSavedMangaById(id: Int) async {
        isLoading = true
        do {
            let currentManga = try await repository.getSavedManga(id: id)
            currentReadingVolumes = currentManga?.readingVolume ?? 0
            currentOwnedVolumes = Set(currentManga?.volumesOwned ?? [])
            isSavedManga = currentManga != nil
        } catch {
            print("Failed to retrieve saved manga by ID: \(error)")
        }
        isLoading = false
    }
        
    
    func addOrUpdateSavedManga(manga: MangaModel, volumesOwned: [Int], volumesRead: Int) async {
        isLoading = true
        do {
           try await repository.addOrUpdateSavedManga(manga: manga, volumesOwned: volumesOwned, volumesRead: volumesRead)
            
        } catch {
            print("Failed to retrieve saved mangas: \(error)")
        }
        isLoading = false
    }
    
    func deleteSavedManga(at offsets: IndexSet) async{
        do {
            for index in offsets {
                try await repository.deleteSavedManga(id: savedMangas[index].id)
            }
        } catch {
            print("Failed to delete saved manga: \(error)")
        }
       
       
    }
    
}

