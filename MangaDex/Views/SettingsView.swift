import SwiftUI

struct SettingsView: View {
    @Environment(LoginViewModel.self) private var loginViewModel
    @State private var showLanguageMenu = false

    var body: some View {
        NavigationStack {
            List {
                Button(action: {
                    showLanguageMenu = true
                }) {
                    Label("Change language", systemImage: "globe")
                }
                .sheet(isPresented: $showLanguageMenu) {
                    TranslationMenuView()
                }

                Button(action: {
                    loginViewModel.logOut()
                }) {
                    Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
