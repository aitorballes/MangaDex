
import SwiftUI

struct LoginView: View {
    @Environment(LoginViewModel.self) private var viewModel
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

            if viewModel.isLoading {
                ProgressView()
            }

            Button(action: {
                Task {
                    await viewModel.login(
                        credentials: CredentialsModel(email: email, password: password)
                    )
                }
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
        .onAppear {
            if let savedCredentials = viewModel.getStoreCredentials() {
                email = savedCredentials.email
                password = savedCredentials.password
            }
        }
    }
}
