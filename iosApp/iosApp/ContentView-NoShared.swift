import SwiftUI

// Temporary version without shared module dependency
struct ContentView_NoShared: View {
    @StateObject private var viewModel = HomeViewModel_NoShared()
    @State private var showingMessages = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.pink)
                        
                        Text("CoupleFox")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Connect with your partner")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Content based on state
                    switch viewModel.uiState {
                    case .loading:
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Loading user data...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        
                    case .error(let errorMessage):
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                            
                            VStack(spacing: 8) {
                                Text("Oops!")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Button("Try Again") {
                                viewModel.loadCurrentUser()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        
                    case .success(let user):
                        VStack(spacing: 20) {
                            // Profile Card
                            VStack(spacing: 16) {
                                Circle()
                                    .fill(Color.pink.gradient)
                                    .frame(width: 80, height: 80)
                                    .overlay {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    }
                                
                                VStack(spacing: 8) {
                                    Text("Welcome back!")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text(user.name)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    
                                    Text(user.email)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(24)
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            
                            // Action Buttons
                            VStack(spacing: 12) {
                                Button("Refresh Data") {
                                    viewModel.loadCurrentUser()
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                
                                Button("View Messages") {
                                    showingMessages = true
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                            }
                        }
                        
                    case .idle:
                        VStack(spacing: 20) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 8) {
                                Text("Get Started")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text("Load your profile to begin")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Button("Load Profile") {
                                viewModel.loadCurrentUser()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .padding(.vertical, 40)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("CoupleFox")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if case .idle = viewModel.uiState {
                viewModel.loadCurrentUser()
            }
        }
        .sheet(isPresented: $showingMessages) {
            MessagesView_NoShared()
        }
    }
}

// Mock data models
struct MockUser {
    let id: String
    let email: String
    let name: String
    let profileImageUrl: String?
    let createdAt: Date
    let updatedAt: Date
}

struct MockMessage {
    let id: String
    let senderId: String
    let receiverId: String
    let content: String
    let timestamp: Date
    let isRead: Bool
}

@MainActor
class HomeViewModel_NoShared: ObservableObject {
    @Published var uiState: HomeUiState_NoShared = .idle
    
    func loadCurrentUser() {
        uiState = .loading
        
        Task {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            
            // Simulate success response
            let mockUser = MockUser(
                id: "1",
                email: "john.doe@example.com",
                name: "John Doe",
                profileImageUrl: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
            
            uiState = .success(mockUser)
        }
    }
}

enum HomeUiState_NoShared {
    case idle
    case loading
    case success(MockUser)
    case error(String)
}

struct MessagesView_NoShared: View {
    @StateObject private var viewModel = MessagesViewModel_NoShared()
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
                            MessageRowView_NoShared(message: message)
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

struct MessageRowView_NoShared: View {
    let message: MockMessage
    
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

@MainActor
class MessagesViewModel_NoShared: ObservableObject {
    @Published var messages: [MockMessage] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func loadMessages() {
        isLoading = true
        errorMessage = nil
        
        Task {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            // Simulate success response
            let mockMessages = [
                MockMessage(
                    id: "1",
                    senderId: "2",
                    receiverId: "1",
                    content: "Hey! How are you doing today?",
                    timestamp: Date().addingTimeInterval(-3600),
                    isRead: true
                ),
                MockMessage(
                    id: "2",
                    senderId: "2",
                    receiverId: "1",
                    content: "I was thinking we could go out for dinner tonight. What do you think?",
                    timestamp: Date().addingTimeInterval(-1800),
                    isRead: false
                ),
                MockMessage(
                    id: "3",
                    senderId: "1",
                    receiverId: "2",
                    content: "That sounds amazing! I'd love to go out with you.",
                    timestamp: Date().addingTimeInterval(-900),
                    isRead: true
                )
            ]
            
            messages = mockMessages
            isLoading = false
        }
    }
}

struct ContentView_NoShared_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_NoShared()
    }
}
