import SwiftUI
import shared

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                switch viewModel.uiState {
                case .loading:
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .error(let errorMessage):
                    VStack(spacing: 16) {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            viewModel.loadCurrentUser()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .success(let user):
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Welcome!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Name: \(user.name)")
                            .font(.body)
                        
                        Text("Email: \(user.email)")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                case .idle:
                    VStack(spacing: 16) {
                        Text("No user data available")
                            .foregroundColor(.secondary)
                        
                        Button("Load User") {
                            viewModel.loadCurrentUser()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
            .navigationTitle("CoupleFox")
        }
        .onAppear {
            viewModel.loadCurrentUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
