import SwiftUI

struct MangaDetailView: View {
    @Environment(SavedMangasViewModel.self) private var viewModel

    let manga: MangaModel
    @State private var showSheet = false
    @State private var volumesOwned: Set<Int> = []
    @State private var selectedReadVolumes: Int = 0
    
    var body: some View {
        @Bindable var viewModel = viewModel
        ScrollView {
            VStack(spacing: 0) {
                if let picture = manga.picture {
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: picture) { phase in
                            switch phase {
                            case .empty:
                                Color.gray.opacity(0.2)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(height: 260)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(manga.title)
                                .font(.largeTitle.bold())
                                .foregroundStyle(.white)
                                .shadow(radius: 2)
                            if let english = manga.titleEnglish, english != manga.title {
                                Text(english)
                                    .font(.title3)
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                            if let japanese = manga.titleJapanese {
                                Text(japanese)
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                        .padding()
                    }
                }
                
                HStack(spacing: 18) {
                    if let score = manga.score {
                        InfoCard(icon: "star.fill", title: "Score", value: String(format: "%.2f", score), color: .yellow)
                    }
                    if let volumes = manga.volumes {
                        InfoCard(icon: "books.vertical.fill", title: "Volumes", value: "\(volumes)", color: .purple)
                    }
                }
                .padding(.top, -24)
                .padding(.bottom, 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    if let fullDate = manga.fullDate {
                        Label(fullDate, systemImage: "calendar")
                            .foregroundStyle(.secondary)
                    }
                    if !manga.authorList.isEmpty {
                        Label(manga.authorList, systemImage: "person.2.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                if !manga.genres.isEmpty || !manga.demographics.isEmpty || !manga.themes.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(manga.genres, id: \.self) { genre in
                                ChipView(text: genre, color: .blue.opacity(0.2))
                            }
                            ForEach(manga.demographics, id: \.self) { demo in
                                ChipView(text: demo, color: .green.opacity(0.2))
                            }
                            ForEach(manga.themes, id: \.self) { theme in
                                ChipView(text: theme, color: .orange.opacity(0.2))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
                
                if let sypnosis = manga.sypnosis {
                    SectionHeader(title: "Synopsis", icon: "text.book.closed")
                    Text(sypnosis)
                        .font(.body)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
                if let background = manga.background {
                    SectionHeader(title: "Awards and publish date", icon: "rosette")
                    Text(background)
                        .font(.callout)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
                if let url = manga.url {
                    SectionHeader(title: "More information", icon: "link")
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "safari")
                            Text("Take a look on MyAnimeList")
                        }
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: viewModel.isSavedManga ? "bookmark.fill" : "bookmark")
                        .imageScale(.large)
                        
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            FavoriteMangaSheet(
                manga: manga,
                collection: $viewModel.currentOwnedVolumes,
                selectedReadVolumes: $viewModel.currentReadingVolumes
            )
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(manga.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.getSavedMangaById(id: manga.id)
        }
    }
}


struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(.thinMaterial)
        .cornerRadius(12)
        .shadow(color: color.opacity(0.15), radius: 4, y: 2)
    }
}

struct ChipView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color)
            .foregroundStyle(.primary)
            .clipShape(Capsule())
    }
}

struct SectionHeader: View {
    let title: LocalizedStringKey
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color.accentColor)
            Text(title)
                .font(.title3.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 2)
    }
}

struct FavoriteMangaSheet: View {
    let manga: MangaModel
    @Binding var collection: Set<Int>
    @Binding var selectedReadVolumes: Int

    @Environment(\.dismiss) var dismiss
    @Environment(SavedMangasViewModel.self) private var viewModel
    
    var volumeRange: [Int] {
        Array(1...(manga.volumes ?? 1))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Information")) {
                    Text(manga.title)
                        .font(.headline)
                    if !manga.authorList.isEmpty {
                        Label(manga.authorList, systemImage: "person.2.fill")
                            .foregroundStyle(.secondary)
                    }
                }
                
                if let volumes = manga.volumes {
                    Section(header: Text("Volumes owned")) {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6),
                            spacing: 12
                        ) {
                            ForEach(volumeRange, id: \.self) { vol in
                                Button(action: {
                                    if collection.contains(vol) {
                                        collection.remove(vol)
                                    } else {
                                        collection.insert(vol)
                                    }
                                }) {
                                    Text("\(vol)")
                                        .frame(width: 36, height: 36)
                                        .background(collection.contains(vol) ? Color.blue : Color.gray.opacity(0.3))
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        .padding(.vertical, 8)
                    }


                    
                    Section(header: Text("Volumes read")) {
                        Stepper(
                            value: $selectedReadVolumes,
                            in: 0...volumes,
                            step: 1
                        ) {
                            Text("\(selectedReadVolumes)")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        Task {
                            await viewModel.addOrUpdateSavedManga(
                                manga: manga,
                                volumesOwned: Array(collection),
                                volumesRead: selectedReadVolumes)
                        }                            
                        dismiss()
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Add to favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

