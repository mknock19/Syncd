import Foundation

// MARK: - SYNC'D Configuration
// ⚠️ This file contains sensitive API keys and should be added to .gitignore

struct Config {
    
    // MARK: - Gemini API
    struct Gemini {
        static let apiKey = "AIzaSyBYazlUCwwgOwadZpCW0H3igRvmRjfrNtE"
        static let model = "gemini-3-flash-preview"
        
        // Model parameters optimized for factual accuracy
        static let temperature: Double = 0.3       // Low for reduced hallucination
        static let topP: Double = 0.9              // Tighter sampling for accuracy
        static let topK: Int = 40
        static let maxOutputTokens: Int = 2048
        
        // API endpoint
        static let baseURL = "https://generativelanguage.googleapis.com/v1beta"
    }
    
    // MARK: - App Settings
    struct App {
        static let name = "SYNC'D"
        static let bundleId = "com.syncd.app"
        static let version = "1.0.0"
    }
}
