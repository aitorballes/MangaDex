struct FiltersModel: Codable {
    let searchTitle: String?
    let searchContains: Bool
    let searchDemographics: [String]?
    let searchThemes: [String]?
    let searchGenres: [String]?
    let searchAuthors: [String]?
}

