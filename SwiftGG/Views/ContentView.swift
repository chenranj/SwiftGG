import SwiftUI

struct ContentView: View {
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
            .sheet(isPresented: $showingSettings, content: {
                if horizontalSizeClass == .compact {
                    // 在 iPhone 上使用全屏 sheet
                    MeView()
                } else {
                    // 在 iPad/Mac 上使用弹窗样式
                    MeView()
                        .frame(width: 400)
                        .presentationDetents([.height(600)])
                }
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())  // 使用堆栈导航样式
    }
}
