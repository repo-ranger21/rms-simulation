import SwiftUI

/// Main dashboard workspace for CivicAI
/// Provides authenticated access to documents, datasets, and task management
struct DashboardView: View {
    @State private var isAuthenticated = true // For demo purposes
    @State private var selectedTab = 0
    @State private var showingChat = false
    
    var body: some View {
        NavigationStack {
            if isAuthenticated {
                authenticatedView
            } else {
                loginView
            }
        }
    }
    
    // MARK: - Authenticated Dashboard View
    private var authenticatedView: some View {
        TabView(selection: $selectedTab) {
            // Documents Section
            documentsView
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Documents")
                }
                .tag(0)
            
            // Datasets Section
            datasetsView
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Datasets")
                }
                .tag(1)
            
            // Tasks Section
            tasksView
                .tabItem {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Tasks")
                }
                .tag(2)
        }
        .navigationTitle("CivicAI Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                chatButton
            }
            ToolbarItem(placement: .navigationBarLeading) {
                profileButton
            }
        }
        .sheet(isPresented: $showingChat) {
            ChatView()
        }
    }
    
    // MARK: - Documents Section
    private var documentsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Quick Actions
                quickActionsSection(
                    title: "Document Actions",
                    actions: [
                        ("Upload Document", "plus.circle.fill", Color.blue),
                        ("Recent Files", "clock.fill", Color.orange),
                        ("Search Archive", "magnifyingglass", Color.green)
                    ]
                )
                
                // Recent Documents
                documentListSection
            }
            .padding()
        }
        .refreshable {
            // Refresh documents
        }
    }
    
    // MARK: - Datasets Section
    private var datasetsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Dataset Overview Cards
                datasetOverviewSection
                
                // Quick Actions
                quickActionsSection(
                    title: "Dataset Actions",
                    actions: [
                        ("Import Dataset", "square.and.arrow.down", Color.purple),
                        ("Create Analysis", "chart.line.uptrend.xyaxis", Color.blue),
                        ("Export Data", "square.and.arrow.up", Color.green)
                    ]
                )
                
                // Dataset List
                datasetListSection
            }
            .padding()
        }
        .refreshable {
            // Refresh datasets
        }
    }
    
    // MARK: - Tasks Section
    private var tasksView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Task Summary
                taskSummarySection
                
                // Quick Actions
                quickActionsSection(
                    title: "Task Actions",
                    actions: [
                        ("New Task", "plus.app.fill", Color.blue),
                        ("Assign Tasks", "person.2.fill", Color.orange),
                        ("View Reports", "doc.text.magnifyingglass", Color.green)
                    ]
                )
                
                // Active Tasks
                activeTasksSection
            }
            .padding()
        }
        .refreshable {
            // Refresh tasks
        }
    }
    
    // MARK: - Login View
    private var loginView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Welcome to CivicAI")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Please authenticate to access your workspace")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Sign In") {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isAuthenticated = true
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Helper Views
    private var chatButton: some View {
        Button {
            showingChat = true
        } label: {
            Image(systemName: "message.circle.fill")
                .font(.title2)
        }
        .accessibilityLabel("Open Chat")
    }
    
    private var profileButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isAuthenticated = false
            }
        } label: {
            Image(systemName: "person.circle")
                .font(.title2)
        }
        .accessibilityLabel("User Profile")
    }
    
    private func quickActionsSection(title: String, actions: [(String, String, Color)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
                    quickActionButton(title: action.0, icon: action.1, color: action.2)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func quickActionButton(title: String, icon: String, color: Color) -> some View {
        Button {
            // Handle action
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    // MARK: - Document Section Views
    private var documentListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Documents")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(0..<5, id: \.self) { index in
                documentRow(title: "Document \(index + 1)", subtitle: "Modified 2 hours ago")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func documentRow(title: String, subtitle: String) -> some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                // Handle document action
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Dataset Section Views
    private var datasetOverviewSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            overviewCard(title: "Total Datasets", value: "24", icon: "chart.bar.fill", color: .blue)
            overviewCard(title: "Active Analysis", value: "8", icon: "chart.line.uptrend.xyaxis", color: .green)
            overviewCard(title: "Storage Used", value: "2.4 GB", icon: "externaldrive.fill", color: .orange)
            overviewCard(title: "Processed Today", value: "156", icon: "gearshape.2.fill", color: .purple)
        }
    }
    
    private func overviewCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var datasetListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Datasets")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(0..<4, id: \.self) { index in
                datasetRow(
                    name: "Dataset \(index + 1)",
                    size: "\(Int.random(in: 10...500)) MB",
                    status: index % 2 == 0 ? "Processing" : "Ready"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func datasetRow(name: String, size: String, status: String) -> some View {
        HStack {
            Image(systemName: "chart.bar.doc.horizontal.fill")
                .foregroundColor(.purple)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .fontWeight(.medium)
                HStack {
                    Text(size)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(status)
                        .font(.caption)
                        .foregroundColor(status == "Ready" ? .green : .orange)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Task Section Views
    private var taskSummarySection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            overviewCard(title: "Total Tasks", value: "42", icon: "list.bullet.clipboard.fill", color: .blue)
            overviewCard(title: "In Progress", value: "12", icon: "clock.fill", color: .orange)
            overviewCard(title: "Completed", value: "28", icon: "checkmark.circle.fill", color: .green)
            overviewCard(title: "Due Today", value: "3", icon: "exclamationmark.triangle.fill", color: .red)
        }
    }
    
    private var activeTasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Tasks")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(0..<5, id: \.self) { index in
                taskRow(
                    title: "Task \(index + 1)",
                    priority: ["High", "Medium", "Low"].randomElement() ?? "Medium",
                    dueDate: "Due in \(Int.random(in: 1...7)) days"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func taskRow(title: String, priority: String, dueDate: String) -> some View {
        HStack {
            Image(systemName: "circle")
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .fontWeight(.medium)
                
                HStack {
                    Text(priority)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(priorityColor(priority).opacity(0.2))
                        .foregroundColor(priorityColor(priority))
                        .cornerRadius(4)
                    
                    Text(dueDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private func priorityColor(_ priority: String) -> Color {
        switch priority {
        case "High": return .red
        case "Medium": return .orange
        case "Low": return .green
        default: return .gray
        }
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
}