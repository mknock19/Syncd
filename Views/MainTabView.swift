import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var dataStore = DataStore()
    
    enum Tab: Int, CaseIterable {
        case home = 0
        case prep = 1
        case scan = 2
        case learn = 3
        case profile = 4
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .prep: return "Prep"
            case .scan: return "Scan"
            case .learn: return "Learn"
            case .profile: return "Profile"
            }
        }
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .prep: return "list.bullet.clipboard.fill"
            case .scan: return "viewfinder"
            case .learn: return "book.fill"
            case .profile: return "person.fill"
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            TabView(selection: $selectedTab) {
                HomeView(selectedTab: $selectedTab)
                    .tag(Tab.home)
                
                PrepView()
                    .tag(Tab.prep)
                
                ScanView()
                    .tag(Tab.scan)
                
                LearnView()
                    .tag(Tab.learn)
                
                ProfileView()
                    .tag(Tab.profile)
            }
            .environmentObject(dataStore)
            
            // Custom Tab Bar
            customTabBar
        }
        .ignoresSafeArea(.keyboard)
    }
    
    // MARK: - Custom Tab Bar
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 6) // Absolute minimum to avoid being hidden by home indicator
        .background(SyncdTheme.Colors.cardBackground)
        .overlay(
            Rectangle()
                .fill(SyncdTheme.Colors.divider)
                .frame(height: 1)
                .frame(maxHeight: .infinity, alignment: .top)
        )
        .ignoresSafeArea(edges: .bottom) // Force content to sit low
    }
    
    @ViewBuilder
    private func tabButton(for tab: Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
            // Haptic feedback
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        } label: {
            VStack(spacing: 6) {
                // Icon with Pill Background
                ZStack {
                    if selectedTab == tab {
                        Capsule()
                            .fill(SyncdTheme.Colors.hotPink.opacity(0.12))
                            .frame(width: 64, height: 32)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(selectedTab == tab ? SyncdTheme.Colors.hotPink : SyncdTheme.Colors.tabBarInactive)
                }
                
                // Label
                Text(tab.title)
                    .font(SyncdTheme.Typography.caption())
                    .foregroundColor(selectedTab == tab ? SyncdTheme.Colors.hotPink : SyncdTheme.Colors.tabBarInactive)
                    .fontWeight(selectedTab == tab ? .semibold : .medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
}
