import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var selectedTab: MainTabView.Tab
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<21:
            return "Good Evening"
        default:
            return "Hey Night Owl"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Greeting Header
                    greetingSection
                    
                    // Daily Tip Card
                    dailyTipCard
                    
                    // Recent Scans Section
                    recentScansSection
                    
                    // Quick Actions
                    quickActionsSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(SyncdTheme.Colors.backgroundPrimary)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Greeting Section
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(greeting),")
                .font(SyncdTheme.Typography.title2())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
            
            Text("Gorgeous! ✨")
                .font(SyncdTheme.Typography.largeTitle())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Daily Tip Card
    private var dailyTipCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(SyncdTheme.Colors.textPlum)
                Text("Daily Hormone Tip")
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(SyncdTheme.Colors.textPlum)
                Spacer()
            }
            
            Text(dataStore.dailyTip.tip)
                .font(SyncdTheme.Typography.body())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
                .lineSpacing(4)
            
            if let source = dataStore.dailyTip.source {
                Text("Source: \(source)")
                    .font(SyncdTheme.Typography.caption())
                    .foregroundColor(SyncdTheme.Colors.textMuted)
                    .italic()
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [SyncdTheme.Colors.backgroundLavender.opacity(0.6), SyncdTheme.Colors.backgroundPeach.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(SyncdTheme.Styles.cornerRadiusLarge)
    }
    
    // MARK: - Recent Scans Section
    private var recentScansSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Scans")
                    .font(SyncdTheme.Typography.title3())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                Spacer()
                if !dataStore.recentScans.isEmpty {
                    Button("See All") {
                        // Navigate to history
                    }
                    .font(SyncdTheme.Typography.subheadline())
                    .foregroundColor(SyncdTheme.Colors.hotPink)
                }
            }
            
            if dataStore.recentScans.isEmpty {
                emptyScansCard
            } else {
                VStack(spacing: 12) {
                    ForEach(dataStore.recentScans.prefix(3)) { product in
                        RecentScanRow(product: product)
                    }
                }
            }
        }
    }
    
    private var emptyScansCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "viewfinder")
                .font(.system(size: 40))
                .foregroundColor(SyncdTheme.Colors.textMuted)
            
            Text("No scans yet!")
                .font(SyncdTheme.Typography.headline())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
            
            Text("Scan your first product to see it here")
                .font(SyncdTheme.Typography.subheadline())
                .foregroundColor(SyncdTheme.Colors.textMuted)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(SyncdTheme.Typography.title3())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            HStack(spacing: 16) {
                QuickActionCard(
                    icon: "viewfinder",
                    title: "Scan",
                    subtitle: "Check a product",
                    color: SyncdTheme.Colors.coral
                ) {
                    // Navigate to Scan tab
                    selectedTab = .scan
                }
                
                QuickActionCard(
                    icon: "heart.fill",
                    title: "Favorites",
                    subtitle: "\(dataStore.favorites.count) saved",
                    color: SyncdTheme.Colors.hotPink
                ) {
                    // Navigate to Profile tab (favorites)
                    selectedTab = .profile
                }
            }
        }
    }
}

// MARK: - Recent Scan Row Component
struct RecentScanRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 16) {
            // Score Circle
            ZStack {
                Circle()
                    .fill(SyncdTheme.scoreColor(for: product.cleanScore).opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Text("\(product.cleanScore)")
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(SyncdTheme.scoreColor(for: product.cleanScore))
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                    .lineLimit(1)
                
                Text(product.brand)
                    .font(SyncdTheme.Typography.subheadline())
                    .foregroundColor(SyncdTheme.Colors.textSecondary)
            }
            
            Spacer()
            
            // Category Tag
            Text(product.category.rawValue)
                .font(SyncdTheme.Typography.caption())
                .foregroundColor(SyncdTheme.Colors.textPlum)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(SyncdTheme.Colors.lavender.opacity(0.3))
                .cornerRadius(SyncdTheme.Styles.cornerRadiusSmall)
        }
        .padding(16)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
    }
}

// MARK: - Quick Action Card Component
struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(SyncdTheme.Typography.headline())
                        .foregroundColor(SyncdTheme.Colors.textPrimary)
                    
                    Text(subtitle)
                        .font(SyncdTheme.Typography.caption())
                        .foregroundColor(SyncdTheme.Colors.textMuted)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(SyncdTheme.Colors.cardBackground)
            .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
            .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
        .environmentObject(DataStore())
}
