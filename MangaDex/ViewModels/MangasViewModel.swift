import Foundation
import Observation

@Observable
final class MangasViewModel {
    let repository: DataRepository

    init(repository: DataRepository = NetworkRepository()) {
        self.repository = repository
    }

    var mangas: [MangaModel] = []
    var isLoading = false
    var currentPage = 0
    var demographics: [String] = []
    var genres: [String] = []
    var themes: [String] = []
    var searchTask: Task<Void, Error>?
    var selectedAuthorsIds:  [String]? = nil {
        didSet {
            Task {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }
    
    var selectedDemographics: [String]? = nil {
        didSet {
            Task {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }
    
    var selectedGenres: [String]? = nil {
        didSet {
            Task {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }
    
    var selectedThemes: [String]? = nil {
        didSet {
            Task {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }
    
    var getFilters: Bool {
        demographics.isEmpty && genres.isEmpty && themes.isEmpty
    }
    
    var hasFilters: Bool {
        !searchText.isEmpty || selectedGenres != nil || selectedThemes != nil || selectedAuthorsIds != nil || selectedDemographics != nil
    }
    
    var searchText: String = "" {
        didSet {
            Task {
                guard !searchText.isEmpty else { return }
                await search()
            }
        }
    }

    func getMangas() async {
        isLoading = true
        do {
            let pagedModel = try await repository.getMangas()
            mangas = pagedModel.mangas
            currentPage = pagedModel.currentPage
        } catch {
            print("Failed to fetch mangas: \(error)")
        }
        isLoading = false
    }
    
    func getNextMangas() async {
        isLoading = true
        do {
            let nextPage = currentPage + 1
            let pagedModel = hasFilters
                ? try await repository.getMangasByFilters(page: nextPage, filters: setCurrentFilters())
                : try await repository.getMangas(page: nextPage)
            mangas.append(contentsOf: pagedModel.mangas)
            currentPage = pagedModel.currentPage
        } catch {
            print("Failed to fetch mangas for page \(currentPage): \(error)")
        }
        isLoading = false            
    }
    
    func applyFilters(filter: FiltersModel) async {
        isLoading = true
        do {
            guard hasFilters else {
                await getMangas()
                return
            }
            let pagedModel = try await repository.getMangasByFilters(page: currentPage, filters: filter)
            mangas = pagedModel.mangas
            currentPage = pagedModel.currentPage
        } catch {
            print("Error applying filters: \(error)")
        }
        isLoading = false
    }
    
    func getFilters() async {
        do {
            demographics = try await repository.getDemographics()
            genres = try await repository.getGenres()
            themes = try await repository.getThemes()
            
            demographics.sort {
                $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
            }
            genres.sort {
                $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
            }
            themes.sort {
                $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
            }
        } catch {
            print("Failed to fetch filters: \(error)")
        }
    }
    
    func clearFilters() {
        selectedAuthorsIds = nil
        selectedDemographics = nil
        selectedGenres = nil
        selectedThemes = nil
    }
    
    private func search() async {
        if searchTask != nil {
            searchTask?.cancel()
            searchTask = nil
        }

        searchTask = Task {
            try await Task.sleep(for: .seconds(0.5))

            if !Task.isCancelled {
                await applyFilters(filter: setCurrentFilters())
            }
        }
    }
    
    private func setCurrentFilters() -> FiltersModel {
        return FiltersModel(
            searchTitle: searchText,
            searchContains: true,
            searchDemographics: selectedDemographics,
            searchThemes: selectedThemes,
            searchGenres: selectedGenres,
            searchAuthors: selectedAuthorsIds
        )

    }
}
