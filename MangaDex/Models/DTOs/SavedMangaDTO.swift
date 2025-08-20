struct SavedMangaDTO: Codable {
    let manga: Int
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int
    
    init(manga: MangaModel, volumesOwned: [Int], volumesRead: Int) {
            self.manga = manga.id
            self.completeCollection = true
            self.volumesOwned = volumesOwned
            self.readingVolume = volumesRead
    }
}
