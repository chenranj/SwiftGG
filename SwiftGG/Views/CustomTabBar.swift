import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showingSettings: Bool
    
    var body: some View {
        HStack {
            Spacer()
            TabButtons(selectedTab: $selectedTab)
                .padding(.trailing, 12)
            SettingsButton(showingSettings: $showingSettings)
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.bottom, 12)
    }
}

// Tab 按钮组
struct TabButtons: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        (icon: "newspaper.fill", label: "新闻"),
        (icon: "swift", label: "文档"),
        (icon: "hands.clap", label: "伙伴")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                let isSelected = selectedTab == index
                let gradient = LinearGradient(
                    colors: [
                        Color(red: 238/255, green: 120/255, blue: 97/255),
                        Color(red: 222/255, green: 93/255, blue: 67/255)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                TabBarButton(
                    imageName: tabs[index].icon,
                    label: tabs[index].label,
                    isSelected: isSelected,
                    gradient: gradient
                ) {
                    withAnimation(.easeInOut) {
                        selectedTab = index
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(height: 44)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
    }
}

// 设置按钮
struct SettingsButton: View {
    @Binding var showingSettings: Bool
    
    var body: some View {
        Button {
            showingSettings = true
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
                .foregroundColor(.gray)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
        }
    }
}

// Tab 按钮
struct TabBarButton: View {
    let imageName: String
    let label: String
    let isSelected: Bool
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: imageName)
                    .font(.system(size: 18))
                    .frame(width: 18)
                if isSelected {
                    Text(label)
                        .font(.system(size: 14))
                        .lineLimit(1)
                }
            }
            .foregroundColor(isSelected ? .white : .gray)
            .frame(height: 32)
            .padding(.horizontal, 12)
            .background(
                Group {
                    if isSelected {
                        gradient
                            .clipShape(Capsule())
                    }
                }
            )
        }
        .frame(minWidth: 44)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0), showingSettings: .constant(false))
} 
