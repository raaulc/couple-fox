import SwiftUI
import shared
import Combine

class HomeViewModel: ObservableObject {
    @Published var uiState: HomeUiState = .idle
    
    private let getCurrentUserUseCase = ServiceLocator.shared.getCurrentUserUseCase
    
    func loadCurrentUser() {
        uiState = .loading
        
        Task {
            do {
                let result = getCurrentUserUseCase()
                switch result {
                case .success(let user):
                    await MainActor.run {
                        self.uiState = .success(user)
                    }
                case .failure(let error):
                    await MainActor.run {
                        self.uiState = .error(error.localizedDescription)
                    }
                }
            } catch {
                await MainActor.run {
                    self.uiState = .error(error.localizedDescription)
                }
            }
        }
    }
}

enum HomeUiState {
    case idle
    case loading
    case success(shared.User)
    case error(String)
}
