import SwiftUI

struct FilterBarView: View {
    @Binding var selectedAuthors: [String]?
    @Binding var selectedGenres: [String]?
    @Binding var selectedThemes: [String]?
    @Binding var selectedDemographics: [String]?
    
    let onTapAuthors: () -> Void
    let onTapGenres: () -> Void
    let onTapThemes: () -> Void
    let onTapDemographics: () -> Void
    let onClear: () -> Void
    
    var hasFilters: Bool {
        selectedAuthors != nil || selectedGenres != nil || selectedThemes != nil || selectedDemographics != nil
    }
    
    var filterSummary: String {
        var summary = [String]()
        if let authors = selectedAuthors, !authors.isEmpty {
            summary.append("\(authors.count) author(s)")
        }
        if let genres = selectedGenres, !genres.isEmpty {
            summary.append("\(genres.count) genre(s)")
        }
        if let themes = selectedThemes, !themes.isEmpty {
            summary.append("\(themes.count) theme(s)")
        }
        if let demographics = selectedDemographics, !demographics.isEmpty {
            summary.append("\(demographics.count) demographic(s)")
        }
        return summary.isEmpty ? "" : summary.joined(separator: ", ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(filterSummary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: onClear) {
                    Image(
                        systemName:
                            "slider.horizontal.2.arrow.trianglehead.counterclockwise"
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .tint(.primary)
                }
                .opacity(hasFilters ? 1 : 0)
            }
            
            
            HStack {
                FilterButton(
                    title: "Authors",
                    count: selectedAuthors?.count,
                    action: onTapAuthors
                )
                
                FilterButton(
                    title: "Genres",
                    count: selectedGenres?.count,
                    action: onTapGenres
                )
                
                FilterButton(
                    title: "Themes",
                    count: selectedThemes?.count,
                    action: onTapThemes
                )
                
                FilterButton(
                    title: "Demographics",
                    count: selectedDemographics?.count,
                    action: onTapDemographics
                )
                
                
            }
        }
    }
}

struct FilterButton: View {
    let title: String
    let count: Int?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
            }
            .font(.footnote)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.primary.opacity(0.1))
            .foregroundStyle(.primary)
            .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}
