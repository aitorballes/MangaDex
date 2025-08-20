import SwiftUI

struct RowView: View {
    let manga: MangaModel
    var body: some View {
        HStack(alignment: .top, spacing: 8) {

            CachedImageView(imageUrl: manga.picture)

            VStack(alignment: .leading, spacing: 4) {
                Text(manga.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(manga.authorList)
                    .lineLimit(2)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    
                
                Label("\(manga.score ?? 0, specifier: "%.1f")", systemImage: "star.fill")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .labelStyle(.titleAndIcon)

                if let volumes = manga.volumes {
                    Label("\(volumes)", systemImage: "character.book.closed.fill.ja")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleAndIcon)
                }

                if let fullDate = manga.fullDate {
                    Label("\(fullDate)", systemImage: "calendar")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleAndIcon)
                }

            }
        }

    }
}

#Preview {
    RowView(manga: .sampleManga)
}
