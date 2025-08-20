import SwiftUI



struct CachedImageView: View {
    @State private var viewModel = CachedImageViewModel()
    
    let imageUrl: URL?
    let width: CGFloat
    let height: CGFloat
    let contentMode: ContentMode

    init(imageUrl: URL?,width: CGFloat = 80, height: CGFloat = 100, contentMode: ContentMode = .fill) {
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
        self.contentMode = contentMode
    }
    
    var body: some View {
        
        if let image = viewModel.image{
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(10)
        } else {
            Image(systemName: "character.book.closed.fill.zh")
                .resizable()
                .aspectRatio(contentMode: contentMode)
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(10)
                .foregroundStyle(.gray)
                .onAppear {
                    viewModel.getImageSynchronously(url: imageUrl)
                }
        }
    }
}
