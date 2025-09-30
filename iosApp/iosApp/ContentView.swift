import SwiftUI
import shared

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()
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
            MessagesView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
