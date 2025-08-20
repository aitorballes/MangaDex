import UIKit

extension UIImage {
    func resizedImage(width: CGFloat) -> UIImage? {
        let scale = width / size.width
        let newHeight = size.height * scale
        let size = CGSize(width: width, height: newHeight)
        return preparingThumbnail(of: size)
    }
}
