import Foundation
import SwiftUI

// MARK: - Product Model
struct Product: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let brand: String
    let barcode: String?
    let category: ProductCategory
    let ingredients: [String]
    let cleanScore: Int  // 0-100
    let analysisDetails: String
    let imageURL: String?
    let isFavorite: Bool
    let scannedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        brand: String,
        barcode: String? = nil,
        category: ProductCategory,
        ingredients: [String],
        cleanScore: Int,
        analysisDetails: String,
        imageURL: String? = nil,
        isFavorite: Bool = false,
        scannedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.barcode = barcode
        self.category = category
        self.ingredients = ingredients
        self.cleanScore = cleanScore
        self.analysisDetails = analysisDetails
        self.imageURL = imageURL
        self.isFavorite = isFavorite
        self.scannedAt = scannedAt
    }
    
    func toggleFavorite() -> Product {
        Product(
            id: id,
            name: name,
            brand: brand,
            barcode: barcode,
            category: category,
            ingredients: ingredients,
            cleanScore: cleanScore,
            analysisDetails: analysisDetails,
            imageURL: imageURL,
            isFavorite: !isFavorite,
            scannedAt: scannedAt
        )
    }
}

enum ProductCategory: String, Codable, CaseIterable {
    case skincare = "Skincare"
    case haircare = "Haircare"
    case makeup = "Makeup"
    case food = "Food"
    case beverage = "Beverage"
    case household = "Household"
    case personalCare = "Personal Care"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .skincare: return "drop.fill"
        case .haircare: return "comb.fill"
        case .makeup: return "paintbrush.fill"
        case .food: return "fork.knife"
        case .beverage: return "cup.and.saucer.fill"
        case .household: return "house.fill"
        case .personalCare: return "heart.fill"
        case .other: return "tag.fill"
        }
    }
}

// MARK: - Article Model (for Learn tab)
struct Article: Identifiable, Codable {
    let id: UUID
    let title: String
    let summary: String
    let content: String
    let category: ArticleCategory
    let source: String           // Citation source name
    let sourceURL: String        // Link to original source
    let publishedAt: Date
    let imageURL: String?
    let readTimeMinutes: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        content: String,
        category: ArticleCategory,
        source: String,
        sourceURL: String,
        publishedAt: Date = Date(),
        imageURL: String? = nil,
        readTimeMinutes: Int = 3
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.category = category
        self.source = source
        self.sourceURL = sourceURL
        self.publishedAt = publishedAt
        self.imageURL = imageURL
        self.readTimeMinutes = readTimeMinutes
    }
}

enum ArticleCategory: String, Codable, CaseIterable {
    case hormoneHealth = "Hormone Health"
    case ingredients = "Ingredients"
    case industryNews = "Industry News"
    case tips = "Tips & Tricks"
    case research = "Research"
    
    var color: Color {
        switch self {
        case .hormoneHealth: return SyncdTheme.Colors.lavender
        case .ingredients: return SyncdTheme.Colors.safeGreen
        case .industryNews: return SyncdTheme.Colors.mutedOrange
        case .tips: return SyncdTheme.Colors.backgroundPeach
        case .research: return SyncdTheme.Colors.backgroundSage
        }
    }
}

// MARK: - Grocery Item Model (for Prep tab)
struct GroceryItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: ProductCategory
    let isCompleted: Bool
    let tips: GroceryTips?
    let addedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        category: ProductCategory,
        isCompleted: Bool = false,
        tips: GroceryTips? = nil,
        addedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.isCompleted = isCompleted
        self.tips = tips
        self.addedAt = addedAt
    }
    
    func toggleCompleted() -> GroceryItem {
        GroceryItem(
            id: id,
            name: name,
            category: category,
            isCompleted: !isCompleted,
            tips: tips,
            addedAt: addedAt
        )
    }
}

struct GroceryTips: Codable {
    let lookFor: [String]
    let avoid: [String]
    let recommendedBrands: [RecommendedBrand]
}

struct RecommendedBrand: Identifiable, Codable {
    let id: UUID
    let name: String
    let cleanScore: Int
    let reason: String
    
    init(
        id: UUID = UUID(),
        name: String,
        cleanScore: Int,
        reason: String
    ) {
        self.id = id
        self.name = name
        self.cleanScore = cleanScore
        self.reason = reason
    }
}

// MARK: - Daily Tip Model
struct DailyTip: Identifiable, Codable {
    let id: UUID
    let title: String
    let tip: String
    let source: String?
    let category: TipCategory
    
    init(
        id: UUID = UUID(),
        title: String,
        tip: String,
        source: String? = nil,
        category: TipCategory = .general
    ) {
        self.id = id
        self.title = title
        self.tip = tip
        self.source = source
        self.category = category
    }
}

enum TipCategory: String, Codable {
    case general = "General"
    case food = "Food"
    case skincare = "Skincare"
    case lifestyle = "Lifestyle"
    case hormones = "Hormones"
}

// MARK: - User Profile
struct UserProfile: Codable {
    var name: String
    var avatarEmoji: String
    var joinedAt: Date
    var totalScans: Int
    var streakDays: Int
    
    init(
        name: String = "Gorgeous",
        avatarEmoji: String = "✨",
        joinedAt: Date = Date(),
        totalScans: Int = 0,
        streakDays: Int = 0
    ) {
        self.name = name
        self.avatarEmoji = avatarEmoji
        self.joinedAt = joinedAt
        self.totalScans = totalScans
        self.streakDays = streakDays
    }
    
    var hormoneHeroStatus: String {
        switch totalScans {
        case 0..<5: return "Newbie"
        case 5..<20: return "Rising Star"
        case 20..<50: return "Clean Queen"
        case 50..<100: return "Hormone Hero"
        default: return "Wellness Warrior"
        }
    }
}

// MARK: - Analysis Result (from Gemini)
struct IngredientAnalysis: Codable {
    let cleanScore: Int
    let summary: String
    let concerns: [IngredientConcern]
    let safeIngredients: [String]
    let sources: [String]  // Citations for accuracy
}

struct IngredientConcern: Identifiable, Codable {
    let id: UUID
    let ingredient: String
    let concern: String
    let severity: ConcernSeverity
    
    init(
        id: UUID = UUID(),
        ingredient: String,
        concern: String,
        severity: ConcernSeverity
    ) {
        self.id = id
        self.ingredient = ingredient
        self.concern = concern
        self.severity = severity
    }
}

enum ConcernSeverity: String, Codable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return SyncdTheme.Colors.cautionYellow
        case .moderate: return SyncdTheme.Colors.mutedOrange
        case .high: return SyncdTheme.Colors.dangerCoral
        }
    }
}
