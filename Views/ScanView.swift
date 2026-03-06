import SwiftUI
import VisionKit
import AVFoundation

struct ScanView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var scanMode: ScanMode = .barcode
    @State private var isShowingScanner = false
    @State private var scannedResult: Product?
    @State private var isAnalyzing = false
    @State private var showingResult = false
    
    enum ScanMode: String, CaseIterable {
        case barcode = "Barcode"
        case ingredients = "Ingredients"
        
        var icon: String {
            switch self {
            case .barcode: return "barcode.viewfinder"
            case .ingredients: return "doc.text.viewfinder"
            }
        }
        
        var description: String {
            switch self {
            case .barcode: return "Scan product barcode"
            case .ingredients: return "Scan ingredient list"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                SyncdTheme.Colors.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Mode Selector
                    modeSelector
                    
                    Spacer()
                    
                    // Scanner Preview / Result
                    if showingResult, let product = scannedResult {
                        resultCard(product: product)
                    } else if isAnalyzing {
                        analyzingView
                    } else {
                        scanPrompt
                    }
                    
                    Spacer()
                    
                    // Scan Button
                    scanButton
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isShowingScanner) {
                CameraScannerSheet(
                    scanMode: scanMode,
                    onScanComplete: { text in
                        isShowingScanner = false
                        if scanMode == .ingredients {
                            analyzeIngredients(text)
                        } else {
                            // For barcode, use mock product lookup
                            simulateBarcodeScan()
                        }
                    },
                    onCancel: {
                        isShowingScanner = false
                    }
                )
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Scan")
                .font(SyncdTheme.Typography.largeTitle())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            Text("Check if products are hormone-safe ✨")
                .font(SyncdTheme.Typography.subheadline())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
    
    // MARK: - Mode Selector
    private var modeSelector: some View {
        HStack(spacing: 0) {
            ForEach(ScanMode.allCases, id: \.rawValue) { mode in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        scanMode = mode
                    }
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: mode.icon)
                            .font(.system(size: 24))
                        Text(mode.rawValue)
                            .font(SyncdTheme.Typography.subheadline())
                    }
                    .foregroundColor(scanMode == mode ? SyncdTheme.Colors.hotPink : SyncdTheme.Colors.textMuted)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        scanMode == mode ?
                        SyncdTheme.Colors.hotPink.opacity(0.1) :
                        Color.clear
                    )
                }
            }
        }
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
    }
    
    // MARK: - Scan Prompt
    private var scanPrompt: some View {
        VStack(spacing: 20) {
            // Viewfinder Icon
            ZStack {
                RoundedRectangle(cornerRadius: SyncdTheme.Styles.cornerRadiusLarge)
                    .stroke(SyncdTheme.Colors.hotPink.opacity(0.3), lineWidth: 3)
                    .frame(width: 200, height: 200)
                
                Image(systemName: scanMode.icon)
                    .font(.system(size: 60))
                    .foregroundColor(SyncdTheme.Colors.hotPink)
            }
            
            Text(scanMode.description)
                .font(SyncdTheme.Typography.headline())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            Text("Tap the button below to start")
                .font(SyncdTheme.Typography.subheadline())
                .foregroundColor(SyncdTheme.Colors.textMuted)
        }
        .padding(32)
    }
    
    // MARK: - Analyzing View
    private var analyzingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(SyncdTheme.Colors.hotPink)
            
            Text("Analyzing ingredients...")
                .font(SyncdTheme.Typography.headline())
                .foregroundColor(SyncdTheme.Colors.textPrimary)
            
            Text("Checking for hormone disruptors")
                .font(SyncdTheme.Typography.subheadline())
                .foregroundColor(SyncdTheme.Colors.textMuted)
        }
        .padding(32)
    }
    
    // MARK: - Result Card
    private func resultCard(product: Product) -> some View {
        VStack(spacing: 20) {
            // Score Ring
            ScoreRing(score: product.cleanScore, size: 120)
            
            // Score Label
            Text(SyncdTheme.scoreLabel(for: product.cleanScore))
                .font(SyncdTheme.Typography.title2())
                .foregroundColor(SyncdTheme.scoreColor(for: product.cleanScore))
            
            // Product Name
            VStack(spacing: 4) {
                Text(product.name)
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                
                Text(product.brand)
                    .font(SyncdTheme.Typography.subheadline())
                    .foregroundColor(SyncdTheme.Colors.textSecondary)
            }
            
            // Analysis Summary
            Text(product.analysisDetails)
                .font(SyncdTheme.Typography.body())
                .foregroundColor(SyncdTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Action Buttons
            HStack(spacing: 16) {
                // Favorite Button
                Button {
                    toggleFavorite(product)
                } label: {
                    HStack {
                        Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        Text(product.isFavorite ? "Saved" : "Save")
                    }
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(product.isFavorite ? .white : SyncdTheme.Colors.hotPink)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(product.isFavorite ? SyncdTheme.Colors.hotPink : SyncdTheme.Colors.hotPink.opacity(0.1))
                    .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
                }
                
                // Scan Again Button
                Button {
                    resetScan()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Scan Again")
                    }
                    .font(SyncdTheme.Typography.headline())
                    .foregroundColor(SyncdTheme.Colors.textSecondary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(SyncdTheme.Colors.backgroundSecondary)
                    .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
                }
            }
        }
        .padding(24)
        .background(SyncdTheme.Colors.cardBackground)
        .cornerRadius(SyncdTheme.Styles.cornerRadiusLarge)
        .shadow(color: SyncdTheme.Styles.shadowColor, radius: SyncdTheme.Styles.shadowRadius, x: 0, y: SyncdTheme.Styles.shadowY)
    }
    
    // MARK: - Scan Button
    private var scanButton: some View {
        Button {
            startScanning()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "viewfinder")
                    .font(.system(size: 24))
                Text("Start Scanning")
                    .font(SyncdTheme.Typography.title3())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [SyncdTheme.Colors.coral, SyncdTheme.Colors.hotPink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(SyncdTheme.Styles.cornerRadiusLarge)
            .shadow(color: SyncdTheme.Colors.hotPink.opacity(0.3), radius: 12, x: 0, y: 6)
        }
    }
    
    // MARK: - Actions
    private func startScanning() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Always show the camera scanner
        isShowingScanner = true
    }
    
    private func simulateBarcodeScan() {
        isAnalyzing = true
        showingResult = false
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Use mock product for demo
            if let mockProduct = MockDatabase.allProducts.randomElement() {
                scannedResult = mockProduct
                dataStore.addToRecentScans(mockProduct)
                showingResult = true
            }
            isAnalyzing = false
        }
    }
    
    private func analyzeIngredients(_ text: String) {
        isAnalyzing = true
        showingResult = false
        
        Task {
            do {
                let result = try await GeminiService.shared.analyzeIngredients(text)
                await MainActor.run {
                    scannedResult = result
                    dataStore.addToRecentScans(result)
                    showingResult = true
                    isAnalyzing = false
                }
            } catch {
                print("Analysis error: \(error)")
                isAnalyzing = false
            }
        }
    }
    
    private func toggleFavorite(_ product: Product) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        dataStore.toggleFavorite(product)
        if let updated = dataStore.favorites.first(where: { $0.id == product.id }) {
            scannedResult = updated
        } else if var current = scannedResult {
            scannedResult = current.toggleFavorite()
        }
    }
    
    private func resetScan() {
        withAnimation {
            scannedResult = nil
            showingResult = false
        }
    }
}

// MARK: - Score Ring Component
struct ScoreRing: View {
    let score: Int
    let size: CGFloat
    
    @State private var animatedScore: Double = 0
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(SyncdTheme.Colors.divider, lineWidth: 12)
            
            // Progress Circle
            Circle()
                .trim(from: 0, to: animatedScore / 100)
                .stroke(
                    SyncdTheme.scoreColor(for: score),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            // Score Text
            VStack(spacing: 0) {
                Text("\(score)")
                    .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
                    .foregroundColor(SyncdTheme.Colors.textPrimary)
                
                Text("/ 100")
                    .font(.system(size: size * 0.12, weight: .medium, design: .rounded))
                    .foregroundColor(SyncdTheme.Colors.textMuted)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedScore = Double(score)
            }
        }
    }
}

#Preview {
    ScanView()
        .environmentObject(DataStore())
}
