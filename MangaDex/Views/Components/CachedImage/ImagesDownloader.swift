import SwiftUI

actor ImagesDownloader {
    static let shared = ImagesDownloader()
    
    private enum ImageStatus {
        case downloading(_ task: Task<UIImage, any Error>)
        case downloaded(_ image: UIImage)
    }
    
    private var cache: [URL: ImageStatus] = [:]
    
    private func downloadImage(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        return image
    }
    
    private func saveImage(url: URL) async throws {
        guard let imageCached = cache[url] else {
            return
        }
        
        guard case .downloaded(let image) = imageCached, let resizedImage = image.resizedImage(width: 300)?.heicData() else {
            return
        }
        
        try resizedImage.write(to: urlDoc(url: url), options: .atomic)
        cache.removeValue(forKey: url)
    }
    
    func getImage(from url: URL) async throws -> UIImage {
        if let status = cache[url] {
            return switch status {
            case .downloading(let task): try await task.value
            case .downloaded(let image): image
            }
        }
        
        let task = Task {
            try await downloadImage(url: url)
        }
        
        cache[url] = .downloading(task)
        
        do {
            let image = try await task.value
            cache[url] = .downloaded(image)
            try await saveImage(url: url)
            return image
        } catch {
            cache.removeValue(forKey: url)
            throw error
        }
    }
    
    nonisolated func urlDoc(url: URL) -> URL {
        let path = url.deletingPathExtension().appendingPathExtension("heic").lastPathComponent
        
        return URL.cachesDirectory.appendingPathComponent(path)
    }
        
}
