import Foundation

// MARK: - Gemini Service
// Integrates with Google's Gemini API for ingredient analysis

class GeminiService {
    static let shared = GeminiService()
    
    private init() {}
    
    // MARK: - Analyze Ingredients
    func analyzeIngredients(_ ingredientsText: String) async throws -> Product {
        // Build the API request
        let url = URL(string: "\(Config.Gemini.baseURL)/models/\(Config.Gemini.model):generateContent?key=\(Config.Gemini.apiKey)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Build prompt for factual, citation-based analysis
        let prompt = buildAnalysisPrompt(ingredientsText: ingredientsText)
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": Config.Gemini.temperature,
                "topP": Config.Gemini.topP,
                "topK": Config.Gemini.topK,
                "maxOutputTokens": Config.Gemini.maxOutputTokens
            ],
            "safetySettings": [
                ["category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"],
                ["category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"],
                ["category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_NONE"],
                ["category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        // Make the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            // Fallback to mock data if API fails
            return createMockAnalysis(from: ingredientsText)
        }
        
        // Parse response
        return try parseGeminiResponse(data: data, originalIngredients: ingredientsText)
    }
    
    // MARK: - Build Analysis Prompt
    private func buildAnalysisPrompt(ingredientsText: String) -> String {
        """
        You are an expert toxicologist and hormone health specialist. Analyze the following product ingredients for potential endocrine (hormone) disrupting chemicals.
        
        IMPORTANT: Only state facts that are supported by peer-reviewed research. Do not make claims without scientific backing.
        
        Ingredients to analyze:
        \(ingredientsText)
        
        Provide your analysis in the following JSON format:
        {
            "productName": "Detected or generic product name",
            "cleanScore": <number 0-100>,
            "summary": "Brief 1-2 sentence summary of overall safety",
            "concerns": [
                {
                    "ingredient": "ingredient name",
                    "concern": "specific concern",
                    "severity": "high/moderate/low",
                    "source": "citation or research reference"
                }
            ],
            "safeIngredients": ["list", "of", "safe", "ingredients"],
            "overallAssessment": "Detailed paragraph about the product's hormone safety profile"
        }
        
        Scoring guidelines:
        - 90-100: Excellent - No concerning ingredients found
        - 70-89: Good - Minor concerns, generally safe
        - 50-69: Moderate - Some concerning ingredients, use with caution
        - 30-49: Poor - Multiple concerning ingredients
        - 0-29: Avoid - Contains known endocrine disruptors
        
        Known endocrine disruptors to flag:
        - Parabens (methylparaben, propylparaben, etc.)
        - Phthalates (often hidden in "fragrance")
        - BPA and BPS
        - Triclosan
        - Oxybenzone
        - PFAS compounds
        - Synthetic musks
        
        Respond ONLY with the JSON object, no additional text.
        """
    }
    
    // MARK: - Parse Gemini Response
    private func parseGeminiResponse(data: Data, originalIngredients: String) throws -> Product {
        // Parse the Gemini API response structure
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            return createMockAnalysis(from: originalIngredients)
        }
        
        // Try to parse the JSON from the response text
        guard let analysisData = text.data(using: .utf8),
              let analysis = try? JSONSerialization.jsonObject(with: analysisData) as? [String: Any] else {
            return createMockAnalysis(from: originalIngredients)
        }
        
        // Extract values
        let productName = analysis["productName"] as? String ?? "Scanned Product"
        let cleanScore = analysis["cleanScore"] as? Int ?? 50
        let summary = analysis["overallAssessment"] as? String ?? analysis["summary"] as? String ?? "Analysis completed."
        let safeIngredients = analysis["safeIngredients"] as? [String] ?? []
        
        return Product(
            name: productName,
            brand: "Scanned Item",
            category: .other,
            ingredients: safeIngredients,
            cleanScore: cleanScore,
            analysisDetails: summary
        )
    }
    
    // MARK: - Mock Analysis Fallback
    private func createMockAnalysis(from ingredientsText: String) -> Product {
        // Simple heuristic-based scoring for demo purposes
        let lowercased = ingredientsText.lowercased()
        
        var score = 75
        var concerns: [String] = []
        
        // Check for known concerning ingredients
        let concerningIngredients = [
            ("paraben", -15, "Parabens may disrupt hormone function"),
            ("fragrance", -10, "May contain undisclosed phthalates"),
            ("parfum", -10, "May contain undisclosed phthalates"),
            ("sodium lauryl sulfate", -5, "Can be irritating"),
            ("oxybenzone", -20, "Known endocrine disruptor"),
            ("triclosan", -15, "Hormone disrupting antibacterial"),
            ("phthalate", -20, "Known endocrine disruptor"),
            ("bpa", -25, "Known endocrine disruptor"),
            ("dmdm hydantoin", -15, "Formaldehyde releaser")
        ]
        
        for (ingredient, penalty, concern) in concerningIngredients {
            if lowercased.contains(ingredient) {
                score += penalty
                concerns.append(concern)
            }
        }
        
        // Clamp score
        score = max(0, min(100, score))
        
        let summary = concerns.isEmpty
            ? "This product appears to be relatively clean based on initial ingredient scan."
            : "Found \(concerns.count) potential concern(s): \(concerns.joined(separator: "; "))"
        
        return Product(
            name: "Scanned Product",
            brand: "Unknown",
            category: .other,
            ingredients: ingredientsText.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) },
            cleanScore: score,
            analysisDetails: summary
        )
    }
}
