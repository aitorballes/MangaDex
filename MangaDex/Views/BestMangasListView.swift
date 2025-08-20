import SwiftUI

struct BestMangasListView: View {
    @State private var viewModel = BestMangasViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.bestMangas) { manga in
                        NavigationLink(value: manga) {
                            MangaCardView(manga: manga)
                                .buttonStyle(.plain)
                                .id(manga.id)
                                .onAppear {
                                    if viewModel.bestMangas.last?.id == manga.id {
                                        Task {
                                            await viewModel.getNextMangas()
                                        }
                                    }
                                }
                        }
                        
                    }
                }
                .padding()
            }
            .navigationTitle("Best Mangas")
            .navigationDestination(for: MangaModel.self) { manga in
                MangaDetailView(manga: manga)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                }
                
                if viewModel.bestMangas.isEmpty && !viewModel.isLoading {
                    ContentUnavailableView(
                        "No content available", systemImage: "character.book.closed.fill.zh",
                        description: Text(
                            "There is no mangas available. Please check your internet connection or try again later."
                        ))
                }
            }
        }
        .task {
            guard viewModel.bestMangas.isEmpty else { return }
            await viewModel.getBestMangas()
        }
    }
}

struct MangaCardView: View {
    let manga: MangaModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedImageView(
                imageUrl: manga.picture,
                width: 140,
                height: 180,
                contentMode: .fill
            )
            .frame(maxHeight: .infinity, alignment: .top)
            Text(manga.titleEnglish ?? manga.title)
                .font(.headline)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                if let score = manga.score {
                    Label(String(format: "%.2f", score), systemImage: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.subheadline)
                }
                Spacer()
                if let vols = manga.volumes {
                    Text("\(vols) vols.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(height: 300)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
}


