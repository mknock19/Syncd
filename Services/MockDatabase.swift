import Foundation

// MARK: - Mock Database
// Pre-populated data for development and demo purposes
// All product scores and article citations are mock data for UI demonstration

struct MockDatabase {
    
    // MARK: - Clean Queen Picks (High scoring pre-scanned products)
    static let cleanQueenPicks: [Product] = [
        Product(
            name: "Pure Glow Moisturizer",
            brand: "Honest Beauty",
            barcode: "859220001234",
            category: .skincare,
            ingredients: ["Water", "Aloe Vera", "Jojoba Oil", "Vitamin E", "Shea Butter"],
            cleanScore: 92,
            analysisDetails: "Free from parabens, sulfates, and synthetic fragrances. Uses plant-based ingredients."
        ),
        Product(
            name: "Clean Shine Shampoo",
            brand: "Briogeo",
            barcode: "859220001235",
            category: .haircare,
            ingredients: ["Water", "Coconut Oil", "Argan Oil", "Biotin", "Rosemary Extract"],
            cleanScore: 88,
            analysisDetails: "Sulfate-free formula with nourishing natural oils. No phthalates or parabens."
        ),
        Product(
            name: "Mineral Glow Foundation",
            brand: "ILIA Beauty",
            barcode: "859220001236",
            category: .makeup,
            ingredients: ["Zinc Oxide", "Titanium Dioxide", "Mica", "Jojoba Oil", "Vitamin E"],
            cleanScore: 94,
            analysisDetails: "Mineral-based with clean ingredients. No synthetic fragrances or talc."
        ),
        Product(
            name: "Organic Baby Lotion",
            brand: "Earth Mama",
            barcode: "859220001237",
            category: .personalCare,
            ingredients: ["Calendula", "Chamomile", "Shea Butter", "Coconut Oil", "Olive Oil"],
            cleanScore: 96,
            analysisDetails: "EWG verified. Free from all common hormone disruptors."
        ),
        Product(
            name: "Glass Bottle Spring Water",
            brand: "Mountain Valley",
            barcode: "859220001238",
            category: .beverage,
            ingredients: ["Natural Spring Water"],
            cleanScore: 98,
            analysisDetails: "No plastic leaching. Glass packaging ensures purity."
        )
    ]
    
    // MARK: - All Products (for barcode lookup simulation)
    static let allProducts: [Product] = cleanQueenPicks + [
        Product(
            name: "Standard Body Wash",
            brand: "Generic Brand",
            barcode: "123456789012",
            category: .personalCare,
            ingredients: ["Water", "Sodium Lauryl Sulfate", "Fragrance", "Methylparaben", "Propylparaben"],
            cleanScore: 35,
            analysisDetails: "Contains parabens and sulfates which may disrupt hormone function. 'Fragrance' may contain phthalates."
        ),
        Product(
            name: "Floral Perfume",
            brand: "Designer Scents",
            barcode: "123456789013",
            category: .personalCare,
            ingredients: ["Alcohol Denat", "Fragrance", "Benzyl Salicylate", "Linalool", "Limonene"],
            cleanScore: 42,
            analysisDetails: "Synthetic fragrance ingredients may contain endocrine disruptors. Limited ingredient transparency."
        ),
        Product(
            name: "Basic Sunscreen SPF 30",
            brand: "Sun Care",
            barcode: "123456789014",
            category: .skincare,
            ingredients: ["Oxybenzone", "Octinoxate", "Homosalate", "Octisalate"],
            cleanScore: 28,
            analysisDetails: "Contains oxybenzone and octinoxate - known hormone disruptors. Consider mineral alternatives."
        ),
        Product(
            name: "Color Protect Conditioner",
            brand: "Salon Pro",
            barcode: "123456789015",
            category: .haircare,
            ingredients: ["Water", "Cetearyl Alcohol", "Dimethicone", "Fragrance", "DMDM Hydantoin"],
            cleanScore: 45,
            analysisDetails: "Contains DMDM Hydantoin (formaldehyde releaser) and synthetic fragrance."
        )
    ]
    
    // MARK: - Daily Tips
    static let dailyTips: [DailyTip] = [
        DailyTip(
            title: "Plastic-Free Hydration",
            tip: "Swap your plastic water bottle for glass or stainless steel today to avoid BPA and other plastic chemicals that can leach into your water!",
            source: "Environmental Working Group",
            category: .lifestyle
        ),
        DailyTip(
            title: "Read Those Labels",
            tip: "Look for 'fragrance' or 'parfum' on labels - this catch-all term can hide hundreds of chemicals, including potential hormone disruptors.",
            source: "Campaign for Safe Cosmetics",
            category: .skincare
        ),
        DailyTip(
            title: "Clean Eating Tip",
            tip: "Choose organic for the 'Dirty Dozen' - strawberries, spinach, and apples often have the highest pesticide residues.",
            source: "Environmental Working Group",
            category: .food
        ),
        DailyTip(
            title: "Microwave Smart",
            tip: "Never microwave food in plastic containers. Even 'microwave safe' plastics can release chemicals when heated.",
            source: "American Academy of Pediatrics",
            category: .lifestyle
        ),
        DailyTip(
            title: "Receipt Check",
            tip: "Thermal receipt paper often contains BPA. Decline receipts when possible or opt for digital versions!",
            source: "Environmental Health Perspectives",
            category: .lifestyle
        )
    ]
    
    // MARK: - Articles for Learn Tab
    static let articles: [Article] = [
        Article(
            title: "The Tea on Seed Oils: What You Need to Know",
            summary: "Understanding the debate around seed oils and what the research actually says about their effects on hormone health.",
            content: "Full article content here...",
            category: .hormoneHealth,
            source: "Harvard School of Public Health",
            sourceURL: "https://www.hsph.harvard.edu/nutritionsource/",
            readTimeMinutes: 5
        ),
        Article(
            title: "Is Your Favorite Soda Brand Going Clean?",
            summary: "Major beverage companies are reformulating products. Here's what's changing and what to look for.",
            content: "Full article content here...",
            category: .industryNews,
            source: "Food & Drug Administration",
            sourceURL: "https://www.fda.gov/",
            readTimeMinutes: 3
        ),
        Article(
            title: "Understanding Endocrine Disruptors",
            summary: "A beginner's guide to chemicals that can interfere with your hormones and where they're commonly found.",
            content: "Full article content here...",
            category: .hormoneHealth,
            source: "National Institute of Environmental Health Sciences",
            sourceURL: "https://www.niehs.nih.gov/",
            readTimeMinutes: 7
        ),
        Article(
            title: "5 Easy Swaps for a Cleaner Bathroom",
            summary: "Simple product swaps that can make a big difference in reducing your exposure to harmful chemicals.",
            content: "Full article content here...",
            category: .tips,
            source: "Environmental Working Group",
            sourceURL: "https://www.ewg.org/",
            readTimeMinutes: 4
        ),
        Article(
            title: "New Study Links Phthalates to Thyroid Issues",
            summary: "Recent research strengthens the connection between common plasticizers and thyroid hormone disruption.",
            content: "Full article content here...",
            category: .research,
            source: "Journal of Clinical Endocrinology & Metabolism",
            sourceURL: "https://academic.oup.com/jcem",
            readTimeMinutes: 6
        )
    ]
    
    // MARK: - Buzz Items (Industry News)
    static let buzzItems: [Article] = [
        Article(
            title: "Clean Beauty Brand Acquired by Conglomerate",
            summary: "What this means for ingredient standards...",
            content: "",
            category: .industryNews,
            source: "Beauty Independent",
            sourceURL: "https://www.beautyindependent.com/",
            readTimeMinutes: 2
        ),
        Article(
            title: "California Bans 24 Toxic Ingredients",
            summary: "New legislation restricts cosmetic chemicals...",
            content: "",
            category: .industryNews,
            source: "California Legislature",
            sourceURL: "https://leginfo.legislature.ca.gov/",
            readTimeMinutes: 2
        ),
        Article(
            title: "FDA Updates Sunscreen Regulations",
            summary: "New safety testing requirements for UV filters...",
            content: "",
            category: .industryNews,
            source: "FDA",
            sourceURL: "https://www.fda.gov/",
            readTimeMinutes: 2
        )
    ]
    
    // MARK: - Grocery Tips
    static func getTipsForItem(_ itemName: String) -> GroceryTips? {
        let lowercased = itemName.lowercased()
        
        if lowercased.contains("shampoo") {
            return GroceryTips(
                lookFor: ["Sulfate-free", "Paraben-free", "No synthetic fragrance"],
                avoid: ["Sodium Lauryl Sulfate", "Parabens", "Fragrance", "DMDM Hydantoin"],
                recommendedBrands: [
                    RecommendedBrand(name: "Briogeo", cleanScore: 88, reason: "Clean, effective formulas"),
                    RecommendedBrand(name: "Prose", cleanScore: 85, reason: "Customized & clean"),
                    RecommendedBrand(name: "Acure", cleanScore: 82, reason: "Affordable & clean")
                ]
            )
        }
        
        if lowercased.contains("lotion") || lowercased.contains("moisturizer") {
            return GroceryTips(
                lookFor: ["Fragrance-free", "Plant-based oils", "No parabens"],
                avoid: ["Parabens", "Phthalates", "Synthetic fragrance", "Mineral oil"],
                recommendedBrands: [
                    RecommendedBrand(name: "Honest Beauty", cleanScore: 92, reason: "EWG Verified"),
                    RecommendedBrand(name: "Vanicream", cleanScore: 90, reason: "Dermatologist trusted"),
                    RecommendedBrand(name: "Pipette", cleanScore: 88, reason: "Clean & gentle")
                ]
            )
        }
        
        if lowercased.contains("sunscreen") {
            return GroceryTips(
                lookFor: ["Mineral/physical sunscreen", "Zinc Oxide", "Titanium Dioxide"],
                avoid: ["Oxybenzone", "Octinoxate", "Homosalate", "Avobenzone"],
                recommendedBrands: [
                    RecommendedBrand(name: "Supergoop", cleanScore: 85, reason: "Reef-safe minerals"),
                    RecommendedBrand(name: "Kinship", cleanScore: 88, reason: "Clean zinc formula"),
                    RecommendedBrand(name: "Beautycounter", cleanScore: 90, reason: "Strict ingredient standards")
                ]
            )
        }
        
        if lowercased.contains("deodorant") {
            return GroceryTips(
                lookFor: ["Aluminum-free", "No synthetic fragrance", "Baking soda or magnesium based"],
                avoid: ["Aluminum compounds", "Parabens", "Triclosan", "Fragrance"],
                recommendedBrands: [
                    RecommendedBrand(name: "Native", cleanScore: 82, reason: "Popular clean option"),
                    RecommendedBrand(name: "Primally Pure", cleanScore: 90, reason: "All natural"),
                    RecommendedBrand(name: "Each & Every", cleanScore: 88, reason: "EWG Verified")
                ]
            )
        }
        
        return nil
    }
}
