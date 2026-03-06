import Foundation
import Combine

// MARK: - DataStore
// Central data management for the app with local persistence

class DataStore: ObservableObject {
    
    // MARK: - Published Properties
    @Published var recentScans: [Product] = []
    @Published var favorites: [Product] = []
    @Published var groceryList: [GroceryItem] = []
    @Published var userProfile: UserProfile = UserProfile()
    @Published var dailyTip: DailyTip
    
    // MARK: - Storage Keys
    private enum StorageKey: String {
        case recentScans = "syncd_recent_scans"
        case favorites = "syncd_favorites"
        case groceryList = "syncd_grocery_list"
        case userProfile = "syncd_user_profile"
        case lastTipDate = "syncd_last_tip_date"
    }
    
    // MARK: - Initialization
    init() {
        // Load daily tip
        self.dailyTip = MockDatabase.dailyTips.randomElement() ?? DailyTip(
            title: "Stay Hydrated",
            tip: "Drink water from glass or stainless steel containers to avoid BPA and other plastic chemicals.",
            source: "Environmental Working Group"
        )
        
        loadData()
    }
    
    // MARK: - Scan History
    func addToRecentScans(_ product: Product) {
        // Remove if already exists (to move to top)
        recentScans.removeAll { $0.id == product.id }
        
        // Add to beginning
        recentScans.insert(product, at: 0)
        
        // Keep only last 20
        if recentScans.count > 20 {
            recentScans = Array(recentScans.prefix(20))
        }
        
        // Update profile stats
        userProfile.totalScans += 1
        
        saveData()
    }
    
    // MARK: - Favorites
    func toggleFavorite(_ product: Product) {
        if let index = favorites.firstIndex(where: { $0.id == product.id }) {
            // Remove from favorites
            favorites.remove(at: index)
        } else {
            // Add to favorites
            let favoritedProduct = product.toggleFavorite()
            favorites.insert(favoritedProduct, at: 0)
        }
        
        // Update in recent scans too
        if let scanIndex = recentScans.firstIndex(where: { $0.id == product.id }) {
            recentScans[scanIndex] = recentScans[scanIndex].toggleFavorite()
        }
        
        saveData()
    }
    
    func isFavorite(_ product: Product) -> Bool {
        favorites.contains { $0.id == product.id }
    }
    
    // MARK: - Grocery List
    func addGroceryItem(_ item: GroceryItem) {
        groceryList.insert(item, at: 0)
        saveData()
    }
    
    func toggleGroceryItem(_ item: GroceryItem) {
        if let index = groceryList.firstIndex(where: { $0.id == item.id }) {
            groceryList[index] = item.toggleCompleted()
            saveData()
        }
    }
    
    func removeGroceryItem(_ item: GroceryItem) {
        groceryList.removeAll { $0.id == item.id }
        saveData()
    }
    
    func clearCompletedItems() {
        groceryList.removeAll { $0.isCompleted }
        saveData()
    }
    
    // MARK: - Persistence
    private func saveData() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(recentScans) {
            UserDefaults.standard.set(encoded, forKey: StorageKey.recentScans.rawValue)
        }
        
        if let encoded = try? encoder.encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: StorageKey.favorites.rawValue)
        }
        
        if let encoded = try? encoder.encode(groceryList) {
            UserDefaults.standard.set(encoded, forKey: StorageKey.groceryList.rawValue)
        }
        
        if let encoded = try? encoder.encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: StorageKey.userProfile.rawValue)
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        
        if let data = UserDefaults.standard.data(forKey: StorageKey.recentScans.rawValue),
           let decoded = try? decoder.decode([Product].self, from: data) {
            recentScans = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: StorageKey.favorites.rawValue),
           let decoded = try? decoder.decode([Product].self, from: data) {
            favorites = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: StorageKey.groceryList.rawValue),
           let decoded = try? decoder.decode([GroceryItem].self, from: data) {
            groceryList = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: StorageKey.userProfile.rawValue),
           let decoded = try? decoder.decode(UserProfile.self, from: data) {
            userProfile = decoded
        }
    }
}
