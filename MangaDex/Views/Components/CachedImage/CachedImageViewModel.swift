import UIKit
import Foundation
import Observation

@Observable
final class CachedImageViewModel {
    let imagesDownloader: ImagesDownloader
    var image: UIImage?
    
    init(imagesDownloader: ImagesDownloader = .shared) {
        self.imagesDownloader = imagesDownloader
    }
    
    @MainActor
    func getImage(url: URL) async {
        do {
            self.image = try await imagesDownloader.getImage(from: url)
        } catch {
            print("Failed to download image: \(error)")
        }
    }
    
    @MainActor
    func getImageSynchronously(url: URL?) {
        guard let url = url else { return }
        let docURL = imagesDownloader.urlDoc(url: url)
        
        if FileManager.default.fileExists(atPath: docURL.path), let data = try? Data(contentsOf: docURL) {
            image = UIImage(data: data)
        } else {
            Task {
                await getImage(url: url)
            }
        }
            
    }
}
