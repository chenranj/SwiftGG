import SwiftUI

struct SponsorsView: View {
    @StateObject private var service = SponsorsService.shared
    
    var body: some View {
        NavigationView {
            Group {
                if service.isLoading {
                    ProgressView("加载中...")
                } else {
                    sponsorsList
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

#Preview {
    SponsorsView()
} 
