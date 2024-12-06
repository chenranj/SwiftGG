import SwiftUI

struct ContentView: View {
    @StateObject private var sponsorsService = SponsorsService.shared
    @StateObject private var contributorsService = ContributorsService.shared
    @State private var selectedTab = 0
    @State private var showingSettings = false
    @State private var hideTabBar = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    PostListView(hideTabBar: $hideTabBar)
                        .tag(0)
                    
                    SwiftGuideView()
                        .tag(1)
                    
                    SponsorsView()
                        .tag(2)
                }
                .animation(.easeInOut, value: selectedTab)
                
                if !hideTabBar {
                    CustomTabBar(selectedTab: $selectedTab, showingSettings: $showingSettings)
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $showingSettings) {
                if horizontalSizeClass == .compact {
                    MeView()
                } else {
                    MeView()
                        .frame(width: 400)
                        .presentationDetents([.height(600)])
                }
            }
            .onAppear {
                Task {
                    await loadData()
                }
            }
            .onChange(of: selectedTab) { _, newValue in
                if newValue == 2 {
                    Task {
                        await sponsorsService.fetchSponsors()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func loadData() async {
        // 并行加载所有初始数据
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await sponsorsService.fetchSponsors() }
            group.addTask { await contributorsService.fetchContributors() }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NetworkMonitor.shared)
}

