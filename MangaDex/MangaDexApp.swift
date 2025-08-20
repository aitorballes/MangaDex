import SwiftUI
import SwiftData

@main
struct MangaDexApp: App {
    @State private var mangasViewModel = MangasViewModel()
    @State private var savedMangasViewModel = SavedMangasViewModel()
    @State private var loginViewModel = LoginViewModel()
    @State private var selectedLocale = Locale(identifier: "es")
    @State private var translationManager = TranslationManager()

    var body: some Scene {
        WindowGroup {
            ContentTabView()
                .environment(mangasViewModel)
                .environment(savedMangasViewModel)
                .environment(loginViewModel)
                .environment(translationManager)
                .environment(\.locale, translationManager.locale)
        }
        .modelContainer(for: [AuthorModel.self ]) { result in
            guard case .success(let container) = result else {
                return
            }
            
            firstLoad(container)
            
        }
    }
    
    private func firstLoad(_ container: ModelContainer) {
        let repository = DataBaseRepositoryImpl(modelContext: container.mainContext)
        let descriptor = FetchDescriptor<AuthorModel>()
        guard (try? container.mainContext.fetchCount(descriptor) == 0) ?? false else {
            return
        }        

        Task {
            do {
                try await repository.importAuthors(NetworkRepository())
            } catch {
                print("Error importing data: \(error)")
            }
        }        
    }
}
