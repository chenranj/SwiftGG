import SwiftUI

struct SponsorsView: View {
    @StateObject private var service = SponsorsService.shared
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        NavigationView {
            Group {
                if !networkMonitor.isConnected {
                    // 离线状态显示
                    VStack(spacing: 16) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("连接互联网查看合作伙伴")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if service.isLoading {
                    // 加载状态
                    ProgressView("加载中...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !service.sponsors.isEmpty {
                    // 显示合作伙伴列表
                    sponsorsList
                } else {
                    // 空状态或错误状态
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("暂无合作伙伴信息")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("合作伙伴")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let url = URL(string: "mailto:sponsor@swiftgg.org?subject=与SwiftGG合作") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image(systemName: "at.badge.plus")
                    }
                }
            }
            .task {
                await service.fetchSponsors()
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 90)
            }
        }
    }
    
    private var sponsorsList: some View {
        List {
            ForEach(Sponsor.SponsorLevel.allCases, id: \.self) { level in
                let levelSponsors = service.sponsors.filter { $0.level == level }
                if !levelSponsors.isEmpty {
                    Section(level.displayName) {
                        ForEach(levelSponsors) { sponsor in
                            SponsorRow(sponsor: sponsor)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await service.fetchSponsors()
        }
    }
}

struct SponsorRow: View {
    let sponsor: Sponsor
    
    var body: some View {
        Link(destination: URL(string: sponsor.websiteURL)!) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: sponsor.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(width: 120, height: 67.5)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text(sponsor.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    SponsorsView()
} 
