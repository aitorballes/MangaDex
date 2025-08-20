import SwiftUI

struct SavedMangasListView: View {
    @Environment(SavedMangasViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.savedMangas) { saved in
                    RowView(manga: saved.manga)
                }
                .onDelete(perform: { indexSet in
                    Task {
                        await viewModel.deleteSavedManga(at: indexSet)
                    }
                })
            }
            .navigationTitle("Saved Mangas")
            .listStyle(.plain)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                }
                
                if viewModel.savedMangas.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView(
                        "No Saved Mangas", systemImage: "character.book.closed.fill.zh",
                        description: Text(
                            "There is no mangas available. Please try to add some mangas to your saved list."
                        ))
                }
            }
        }
        .task {
            await viewModel.getSavedMangas()
        }
    }
    
}

#Preview {
    SavedMangasListView()
}
