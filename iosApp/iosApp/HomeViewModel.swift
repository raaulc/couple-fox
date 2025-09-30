import SwiftUI
import shared
import Combine

@MainActor
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
                    uiState = .success(user)
                case .failure(let error):
                    uiState = .error(error.localizedDescription)
                }
            } catch {
                uiState = .error(error.localizedDescription)
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
