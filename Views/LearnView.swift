import SwiftUI

struct LearnView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var selectedCategory: ArticleCategory? = nil
    
    var filteredArticles: [Article] {
        if let category = selectedCategory {
            return MockDatabase.articles.filter { $0.category == category }
        }
        return MockDatabase.articles
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                    
                    // Category Pills
                    categoryFilter
                    
                    // Featured Article
                    if let featured = MockDatabase.articles.first {
                        featuredCard(article: featured)
                    }
                    
                    // The Buzz Section
                    theBuzzSection
                    
                    // Article Feed
                    articleFeed
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(SyncdTheme.Colors.backgroundPrimary)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Learn")
                .font(SyncdTheme.Typography.largeTitle())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            Text("Stay informed, stay empowered 📚")
                .font(SyncdTheme.Typography.subheadline())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All Button
                CategoryPill(
                    title: "All",
                    isSelected: selectedCategory == nil,
                    color: SyncdTheme.Colors.hotPink
                ) {
                    selectedCategory = nil
                }
                
                // Category Buttons
                ForEach(ArticleCategory.allCases, id: \.rawValue) { category in
                    CategoryPill(
                        title: category.rawValue,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
    
    // MARK: - Featured Card
    private func featuredCard(article: Article) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Category Badge
            HStack {
                Text(article.category.rawValue)
                    .font(SyncdTheme.Typography.caption())
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(article.category.color)
                    .cornerRadius(SyncdTheme.Styles.cornerRadiusSmall)
                
                Spacer()
                
                Text("Featured")
                    .font(SyncdTheme.Typography.caption())
                    .foregroundColor(SyncdTheme.Colors.hotPink)
            }
            
            // Title
            Text(article.title)
                .font(SyncdTheme.Typography.title2())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
                .lineLimit(3)
            
            // Summary
            Text(article.summary)
                .font(SyncdTheme.Typography.body())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
                .lineLimit(2)
            
            // Footer
            HStack {
                // Source Citation
                HStack(spacing: 4) {
                    Image(systemName: "link")
                        .font(.system(size: 12))
                    Text(article.source)
                        .font(SyncdTheme.Typography.caption())
                }
                .foregroundColor(SyncdTheme.Colors.textMuted)
                
                Spacer()
                
                // Read Time
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("\(article.readTimeMinutes) min read")
                        .font(SyncdTheme.Typography.caption())
                }
                .foregroundColor(SyncdTheme.Colors.textMuted)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [SyncdTheme.Colors.backgroundPeach.opacity(0.5), SyncdTheme.Colors.backgroundLavender.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(SyncdTheme.Styles.cornerRadiusLarge)
    }
    
    // MARK: - The Buzz Section
    private var theBuzzSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("The Buzz 🐝")
                    .font(SyncdTheme.Typography.title3())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(MockDatabase.buzzItems) { buzz in
                        BuzzCard(article: buzz)
                    }
                }
            }
        }
    }
    
    // MARK: - Article Feed
    private var articleFeed: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Latest Articles")
                .font(SyncdTheme.Typography.title3())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            VStack(spacing: 16) {
                ForEach(filteredArticles.dropFirst()) { article in
                    ArticleRow(article: article)
                }
            }
        }
    }
}

// MARK: - Category Pill Component
struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(SyncdTheme.Typography.subheadline())
                .foregroundColor(isSelected ? .white : SyncdTheme.Colors.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? color : SyncdTheme.Colors.cardBackground)
                .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
                .shadow(color: isSelected ? color.opacity(0.3) : SyncdTheme.Styles.shadowColor, radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Buzz Card Component
struct BuzzCard: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category
            Text(article.category.rawValue)
                .font(SyncdTheme.Typography.caption())
                .foregroundColor(article.category.color)
            
            // Title
            Text(article.title)
                .font(SyncdTheme.Typography.headline())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
                .lineLimit(3)
            
            Spacer()
            
            // Source (Citation)
            HStack(spacing: 4) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 10))
                Text(article.source)
                    .font(SyncdTheme.Typography.caption())
            }
            .foregroundColor(SyncdTheme.Colors.textMuted)
        }
        .padding(16)
        .frame(width: 180, height: 160)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
    }
}

// MARK: - Article Row Component
struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        HStack(spacing: 16) {
            // Colored Indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(article.category.color)
                .frame(width: 4)
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Category & Time
                HStack {
                    Text(article.category.rawValue)
                        .font(SyncdTheme.Typography.caption())
                        .foregroundColor(article.category.color)
                    
                    Spacer()
                    
                    Text("\(article.readTimeMinutes) min")
                        .font(SyncdTheme.Typography.caption())
                        .foregroundColor(SyncdTheme.Colors.textMuted)
                }
                
                // Title
                Text(article.title)
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                    .lineLimit(2)
                
                // Source Citation
                HStack(spacing: 4) {
                    Image(systemName: "link")
                        .font(.system(size: 10))
                    Text("Source: \(article.source)")
                        .font(SyncdTheme.Typography.caption())
                }
                .foregroundColor(SyncdTheme.Colors.textMuted)
            }
            
            // Arrow
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(SyncdTheme.Colors.textMuted)
        }
        .padding(16)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: 4, x: 0, y: 2)
    }
}

#Preview {
    LearnView()
        .environmentObject(DataStore())
}
