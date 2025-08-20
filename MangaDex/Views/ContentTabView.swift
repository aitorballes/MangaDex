import SwiftData
import SwiftUI

struct ContentTabView: View {
    @Environment(LoginViewModel.self) private var loginViewModel

    @State private var showLogin = false

    var body: some View {
        @Bindable var loginViewModel = loginViewModel
        TabView {
            Tab("Best Mangas", systemImage: "character.book.closed.fill.zh") {
                BestMangasListView()
            }
            Tab("Discover", systemImage: "text.page.badge.magnifyingglass") {
                MangasListView()
            }
            Tab("Saved", systemImage: "bookmark.fill") {
                SavedMangasListView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .fullScreenCover(isPresented: $loginViewModel.isNotLoggedIn) {
            LoginView()
        }
    }
}

#Preview {
    ContentTabView()
}
