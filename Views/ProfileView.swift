import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingSettings = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // User Header
                    userHeaderSection
                    
                    // Stats Cards
                    statsSection
                    
                    // My Favorites Section
                    favoritesSection
                    
                    // Settings Section
                    settingsSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(SyncdTheme.Colors.backgroundPrimary)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - User Header
    private var userHeaderSection: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [SyncdTheme.Colors.lavender, SyncdTheme.Colors.backgroundPeach],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Text(dataStore.userProfile.avatarEmoji)
                    .font(.system(size: 50))
            }
            
            // Name & Status
            VStack(spacing: 4) {
                Text("Hey, \(dataStore.userProfile.name)!")
                    .font(SyncdTheme.Typography.title2())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(SyncdTheme.Colors.mutedOrange)
                    Text(dataStore.userProfile.hormoneHeroStatus)
                        .font(SyncdTheme.Typography.subheadline())
                        .foregroundColor(SyncdTheme.Colors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusLarge)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 16) {
            StatCard(
                icon: "viewfinder",
                value: "\(dataStore.userProfile.totalScans)",
                label: "Scans",
                color: SyncdTheme.Colors.coral
            )
            
            StatCard(
                icon: "heart.fill",
                value: "\(dataStore.favorites.count)",
                label: "Favorites",
                color: SyncdTheme.Colors.hotPink
            )
            
            StatCard(
                icon: "flame.fill",
                value: "\(dataStore.userProfile.streakDays)",
                label: "Day Streak",
                color: SyncdTheme.Colors.mutedOrange
            )
        }
    }
    
    // MARK: - Favorites Section
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("My Favorites 💕")
                    .font(SyncdTheme.Typography.title3())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                Spacer()
                if !dataStore.favorites.isEmpty {
                    Text("\(dataStore.favorites.count) items")
                        .font(SyncdTheme.Typography.subheadline())
                        .foregroundColor(SyncdTheme.Colors.textMuted)
                }
            }
            
            if dataStore.favorites.isEmpty {
                emptyFavoritesCard
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(dataStore.favorites) { product in
                        FavoriteProductCard(product: product) {
                            dataStore.toggleFavorite(product)
                        }
                    }
                }
            }
        }
    }
    
    private var emptyFavoritesCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.system(size: 40))
                .foregroundColor(SyncdTheme.Colors.textMuted)
            
            Text("No favorites yet")
                .font(SyncdTheme.Typography.headline())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
            
            Text("Heart products while scanning to save them here!")
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
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(SyncdTheme.Typography.title3())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRow(icon: "bell.fill", title: "Notifications", color: SyncdTheme.Colors.coral) {
                    // Navigate to notifications
                }
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(icon: "person.fill", title: "Account", color: SyncdTheme.Colors.lavender) {
                    // Navigate to account
                }
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: SyncdTheme.Colors.safeGreen) {
                    // Navigate to help
                }
                
                Divider()
                    .padding(.leading, 56)
                
                SettingsRow(icon: "info.circle.fill", title: "About SYNC'D", color: SyncdTheme.Colors.mutedOrange) {
                    // Navigate to about
                }
            }
            .background(SyncdTheme.Colors.cardBackground)
            .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
            .shadow(color: SyncdTheme.Styles.shadowColor, radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(SyncdTheme.Typography.title2())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            Text(label)
                .font(SyncdTheme.Typography.caption())
                .foregroundColor(SyncdTheme.Colors.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Favorite Product Card Component
struct FavoriteProductCard: View {
    let product: Product
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Score Badge & Heart
            HStack {
                // Score
                Text("\(product.cleanScore)")
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(SyncdTheme.scoreColor(for: product.cleanScore))
                    .cornerRadius(SyncdTheme.Styles.cornerRadiusSmall)
                
                Spacer()
                
                // Remove Button
                Button(action: onRemove) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(SyncdTheme.Colors.hotPink)
                }
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(SyncdTheme.Typography.subheadline())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                    .lineLimit(2)
                
                Text(product.brand)
                    .font(SyncdTheme.Typography.caption())
                    .foregroundColor(SyncdTheme.Colors.textMuted)
            }
        }
        .padding(16)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Settings Row Component
struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                    .frame(width: 40)
                
                Text(title)
                    .font(SyncdTheme.Typography.body())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(SyncdTheme.Colors.textMuted)
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView()
        .environmentObject(DataStore())
}
