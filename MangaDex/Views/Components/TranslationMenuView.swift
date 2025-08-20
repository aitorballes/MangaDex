import SwiftUI

struct TranslationMenuView: View {
    @Environment(TranslationManager.self) var translationManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List(AppLanguage.allCases) { language in
            Button {
                translationManager.setLanguage(language)
                dismiss()
            } label: {
                HStack {
                    Text(language.displayName)
                    if translationManager.currentLanguage == language {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
        .navigationTitle("Choose language")
    }
}
