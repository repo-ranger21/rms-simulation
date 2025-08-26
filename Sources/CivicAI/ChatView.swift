import SwiftUI

/// Chat interface for CivicAI workspace
/// Provides conversational AI interaction for users
struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages List
                messagesView
                
                Divider()
                
                // Input Area
                inputView
            }
            .navigationTitle("CivicAI Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Clear Chat") {
                            clearChat()
                        }
                        Button("Export Chat") {
                            exportChat()
                        }
                        Button("Settings") {
                            // Open settings
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .onAppear {
            loadInitialMessages()
        }
    }
    
    // MARK: - Messages View
    private var messagesView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    if messages.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(messages) { message in
                            messageRow(message: message)
                        }
                        
                        if isLoading {
                            typingIndicator
                        }
                    }
                }
                .padding()
            }
            .onChange(of: messages.count) { _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo(messages.last?.id, anchor: .bottom)
                }
            }
            .onChange(of: isLoading) { _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo("typing", anchor: .bottom)
                }
            }
        }
    }
    
    // MARK: - Input View
    private var inputView: some View {
        HStack(spacing: 12) {
            // Message input
            HStack {
                TextField("Type your message...", text: $messageText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...4)
                
                if !messageText.isEmpty {
                    Button {
                        clearInput()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            
            // Send button
            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundColor(messageText.isEmpty ? .secondary : .blue)
            }
            .disabled(messageText.isEmpty)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helper Views
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "message.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue.opacity(0.6))
            
            Text("Welcome to CivicAI Chat")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Ask me about your documents, datasets, or tasks.\nI'm here to help with your civic AI workspace!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                suggestionButton("Analyze recent documents")
                suggestionButton("Show dataset summary")
                suggestionButton("List pending tasks")
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func suggestionButton(_ text: String) -> some View {
        Button {
            messageText = text
        } label: {
            Text(text)
                .font(.callout)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(20)
        }
    }
    
    private var typingIndicator: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 6, height: 6)
                        .opacity(0.6)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: isLoading
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            
            Spacer()
        }
        .id("typing")
    }
    
    private func messageRow(message: ChatMessage) -> some View {
        HStack {
            if message.isFromUser {
                Spacer(minLength: 60)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                    Text(message.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.top, 2)
                        
                        Text(message.content)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .cornerRadius(12)
                    }
                    
                    HStack {
                        Text(message.timestamp, style: .time)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(.leading, 24)
                }
                
                Spacer(minLength: 60)
            }
        }
    }
    
    // MARK: - Actions
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(
            content: messageText,
            isFromUser: true,
            timestamp: Date()
        )
        
        messages.append(userMessage)
        
        let messageToProcess = messageText
        messageText = ""
        
        // Simulate AI response
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            let aiResponse = generateAIResponse(for: messageToProcess)
            messages.append(aiResponse)
        }
    }
    
    private func generateAIResponse(for message: String) -> ChatMessage {
        let responses = [
            "I'd be happy to help with that! Let me analyze your request.",
            "Based on your workspace data, here's what I found...",
            "That's a great question! Here are some insights from your CivicAI workspace.",
            "I can help you with that task. Let me gather the relevant information.",
            "Here's a summary of what you're looking for in your workspace."
        ]
        
        return ChatMessage(
            content: responses.randomElement() ?? "How can I assist you further?",
            isFromUser: false,
            timestamp: Date()
        )
    }
    
    private func clearInput() {
        messageText = ""
    }
    
    private func clearChat() {
        messages.removeAll()
    }
    
    private func exportChat() {
        // Implement chat export functionality
    }
    
    private func loadInitialMessages() {
        // Load any saved messages or show welcome message
        if messages.isEmpty {
            messages.append(
                ChatMessage(
                    content: "Hello! I'm your CivicAI assistant. How can I help you today?",
                    isFromUser: false,
                    timestamp: Date()
                )
            )
        }
    }
}

// MARK: - Chat Message Model
struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp: Date
}

// MARK: - Preview
#Preview {
    ChatView()
}