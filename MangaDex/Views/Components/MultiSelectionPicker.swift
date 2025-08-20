import SwiftUI

struct MultiSelectionPicker<T: Identifiable & CustomStringConvertible>: View {
    let title: String
    let options: [T]
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedOptions: [T.ID]?
    @State private var searchText = ""
    
    var filteredOptions: [T] {
        if searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.description.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var hasSelectedOptions: Bool {
        selectedOptions != nil && !(selectedOptions?.isEmpty ?? true)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredOptions) { option in
                    Button {
                        if selectedOptions?.contains(option.id) ?? false {
                            selectedOptions?.removeAll { $0 == option.id }
                        } else {
                            selectedOptions = (selectedOptions ?? []) + [option.id]
                        }
                    } label: {
                        HStack {
                            Text(option.description)
                            Spacer()
                            if selectedOptions?.contains(option.id) ?? false {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text(hasSelectedOptions ? "Apply" : "Close")
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
