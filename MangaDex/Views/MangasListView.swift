import SwiftUI
import SwiftData

struct MangasListView: View {
    @Environment(MangasViewModel.self) private var viewModel
    @State private var showFilters = false
    @State private var activePicker: PickerType?
    @Query(sort: [SortDescriptor(\AuthorModel.firstName, order: .forward)]) private var authors: [AuthorModel]
    
    enum PickerType: String, CaseIterable, Identifiable  {
        case authors, genres, themes, demographics
        var id: String { self.rawValue }
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            if showFilters {
                FilterBarView(
                    selectedAuthors: $viewModel.selectedAuthorsIds,
                    selectedGenres: $viewModel.selectedGenres,
                    selectedThemes: $viewModel.selectedThemes,
                    selectedDemographics: $viewModel.selectedDemographics,
                    onTapAuthors: { activePicker = .authors},
                    onTapGenres: { activePicker = .genres },
                    onTapThemes: { activePicker = .themes },
                    onTapDemographics: { activePicker = .demographics },
                    onClear: { viewModel.clearFilters() }
                )
                .padding(.horizontal)
            }
            List {
                ForEach(viewModel.mangas) { manga in
                    NavigationLink(value: manga) {
                        RowView(manga: manga)
                            .id(manga.id)
                            .onAppear {
                                if viewModel.mangas.last?.id == manga.id {
                                    Task {
                                        await viewModel.getNextMangas()
                                    }
                                }
                            }
                    }
                }
            }
            .navigationTitle("Discover")
            .navigationDestination(for: MangaModel.self) { manga in
                MangaDetailView(manga: manga)
            }
            .listStyle(.plain)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                }
                
                if viewModel.mangas.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView(
                        "No Mangas", systemImage: "character.book.closed.fill.zh",
                        description: Text(
                            "There is no mangas available. Please try to modify your filters"
                        ))
                }
                
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search..."
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                            showFilters.toggle()
                    } label: {
                        Image(systemName: "slider.vertical.3")
                            .imageScale(.large)
                            .tint(.primary)
                    }
                }
            }
            .refreshable {
                await viewModel.getMangas()
            }
            .sheet(item: $activePicker) { type in
                switch type {
                case .authors:
                    MultiSelectionPicker(
                        title: "Authors",
                        options: authors,
                        selectedOptions: $viewModel.selectedAuthorsIds
                    )
                case .genres:
                    MultiSelectionPicker(
                        title: "Genres",
                        options: viewModel.genres,
                        selectedOptions: $viewModel.selectedGenres
                    )
                case .themes:
                    MultiSelectionPicker(
                        title: "Themes",
                        options: viewModel.themes,
                        selectedOptions: $viewModel.selectedThemes
                    )
                case .demographics:
                    MultiSelectionPicker(
                        title: "Demographics",
                        options: viewModel.demographics,
                        selectedOptions: $viewModel.selectedDemographics
                    )
                }
            }
            
        }
        .task {
            if viewModel.mangas.isEmpty {
                await viewModel.getMangas()
            }
            
            if viewModel.getFilters {
                await viewModel.getFilters()
            }
        }
    }
}

#Preview {
    MangasListView()
        .environment(MangasViewModel())
}
