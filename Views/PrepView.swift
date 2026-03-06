import SwiftUI

struct PrepView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var newItemName = ""
    @State private var showingTips = false
    @State private var selectedCategory: ProductCategory = .other
    @State private var showingCategoryPicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                    
                    // Add Item Section
                    addItemSection
                    
                    // My List Section
                    myListSection
                    
                    // Clean Queen Picks Section
                    cleanQueenPicksSection
                    
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
            Text("Prep")
                .font(SyncdTheme.Typography.largeTitle())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            Text("Your hormone-safe shopping guide 🛒")
                .font(SyncdTheme.Typography.subheadline())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Add Item Section
    private var addItemSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Text Field
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(SyncdTheme.Colors.hotPink)
                    
                    TextField("Add to list...", text: $newItemName)
                        .font(SyncdTheme.Typography.body())
                        .foregroundColor(SyncdTheme.Colors.textPrimary)
                        .onSubmit {
                            addItem()
                        }
                }
                .padding(16)
                .background(SyncdTheme.Colors.cardBackground)
                .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
                .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
                
                // Add Button
                Button {
                    addItem()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(SyncdTheme.Colors.hotPink)
                }
                .disabled(newItemName.isEmpty)
                .opacity(newItemName.isEmpty ? 0.5 : 1)
            }
        }
    }
    
    private func addItem() {
        guard !newItemName.isEmpty else { return }
        
        let tips = MockDatabase.getTipsForItem(newItemName)
        let item = GroceryItem(
            name: newItemName,
            category: selectedCategory,
            tips: tips
        )
        dataStore.addGroceryItem(item)
        newItemName = ""
        
        // Show tips popup if available
        if tips != nil {
            showingTips = true
        }
        
        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    // MARK: - My List Section
    private var myListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("My List")
                    .font(SyncdTheme.Typography.title3())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                
                Spacer()
                
                if !dataStore.groceryList.isEmpty {
                    Text("\(dataStore.groceryList.filter { !$0.isCompleted }.count) items")
                        .font(SyncdTheme.Typography.subheadline())
                        .foregroundColor(SyncdTheme.Colors.textMuted)
                }
            }
            
            if dataStore.groceryList.isEmpty {
                emptyListCard
            } else {
                VStack(spacing: 8) {
                    ForEach(dataStore.groceryList) { item in
                        GroceryRow(item: item) {
                            dataStore.toggleGroceryItem(item)
                        } onShowTips: {
                            // Show tips sheet
                        }
                    }
                }
            }
        }
    }
    
    private var emptyListCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "list.bullet.clipboard")
                .font(.system(size: 40))
                .foregroundColor(SyncdTheme.Colors.textMuted)
            
            Text("Your list is empty")
                .font(SyncdTheme.Typography.headline())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
            
            Text("Add items to get clean shopping tips!")
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
    
    // MARK: - Clean Queen Picks
    private var cleanQueenPicksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Clean Queen Picks 👑")
                    .font(SyncdTheme.Typography.title3())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                Spacer()
            }
            
            Text("Pre-scanned products with high safety scores")
                .font(SyncdTheme.Typography.subheadline())
                .foregroundColor(SyncdTheme.Colors.textMuted)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(MockDatabase.cleanQueenPicks) { product in
                        CleanQueenCard(product: product)
                    }
                }
            }
        }
    }
}

// MARK: - Grocery Row Component
struct GroceryRow: View {
    let item: GroceryItem
    let onToggle: () -> Void
    let onShowTips: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(item.isCompleted ? SyncdTheme.Colors.safeGreen : SyncdTheme.Colors.textMuted)
            }
            
            // Item Name
            Text(item.name)
                .font(SyncdTheme.Typography.body())
                .foregroundColor(item.isCompleted ? SyncdTheme.Colors.textMuted : SyncdTheme.Colors.textPrimary)
                .strikethrough(item.isCompleted, color: SyncdTheme.Colors.textMuted)
            
            Spacer()
            
            // Tips Button (if available)
            if item.tips != nil {
                Button(action: onShowTips) {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text("Tips")
                    }
                    .font(SyncdTheme.Typography.caption())
                    .foregroundColor(SyncdTheme.Colors.hotPink)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(SyncdTheme.Colors.hotPink.opacity(0.1))
                    .cornerRadius(SyncdTheme.Styles.cornerRadiusSmall)
                }
            }
        }
        .padding(16)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: 4, x: 0, y: 2)
    }
}

// MARK: - Clean Queen Card Component
struct CleanQueenCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Score Badge
            HStack {
                Spacer()
                Text("\(product.cleanScore)")
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(SyncdTheme.Colors.safeGreen)
                    .cornerRadius(SyncdTheme.Styles.cornerRadiusSmall)
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                    .lineLimit(2)
                
                Text(product.brand)
                    .font(SyncdTheme.Typography.subheadline())
                    .foregroundColor(SyncdTheme.Colors.textSecondary)
                
                // Category Tag
                Text(product.category.rawValue)
                    .font(SyncdTheme.Typography.caption())
                    .foregroundColor(SyncdTheme.Colors.textPlum)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(SyncdTheme.Colors.lavender.opacity(0.3))
                    .cornerRadius(8)
                    .padding(.top, 4)
            }
        }
        .padding(16)
        .frame(width: 160)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
    }
}

#Preview {
    PrepView()
        .environmentObject(DataStore())
}
