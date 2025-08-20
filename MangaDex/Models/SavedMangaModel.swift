struct SavedMangaModel: Identifiable {
    var id: Int { manga.id }
    let manga: MangaModel
    let completeCollection: Bool
    let readingVolume: Int
    let volumesOwned: [Int]
    
}
