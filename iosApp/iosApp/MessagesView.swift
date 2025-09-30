import SwiftUI
import shared

struct MessagesView: View {
    @StateObject private var viewModel = MessagesViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView("Loading messages...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "message.badge.filled.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Failed to load messages")
                            .font(.headline)
                        
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Retry") {
                            viewModel.loadMessages()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.messages, id: \.id) { message in
                            MessageRowView(message: message)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadMessages()
        }
    }
}

struct MessageRowView: View {
    let message: shared.Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.blue.gradient)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("User \(message.senderId)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(formatDate(message.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message.content)
                    .font(.body)
                    .foregroundColor(.primary)
                
                if !message.isRead {
                    HStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                        
                        Text("Unread")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ timestamp: Kotlinx_datetimeInstant) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp.epochSeconds))
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

@MainActor
class MessagesViewModel: ObservableObject {
    @Published var messages: [shared.Message] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let getMessagesUseCase = ServiceLocator.shared.getMessagesUseCase
    
    func loadMessages() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = getMessagesUseCase(userId: "current-user-id")
                switch result {
                case .success(let messagesList):
                    messages = messagesList
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
