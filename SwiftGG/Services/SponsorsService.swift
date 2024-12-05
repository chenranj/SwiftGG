import Foundation

struct Sponsor: Codable, Identifiable {
    let id: String
    let name: String
    let imageURL: String
    let websiteURL: String
    let level: SponsorLevel
    
    enum SponsorLevel: String, Codable, CaseIterable {
        case diamond = "diamond"
        case platinum = "platinum"
        case gold = "gold"
        case silver = "silver"
        
        var displayName: String {
            switch self {
            case .diamond: return "钻石合作伙伴"
            case .platinum: return "白金合作伙伴"
            case .gold: return "黄金合作伙伴"
            case .silver: return "白银合作伙伴"
            }
        }
    }
}

// 添加响应模型
struct SponsorsResponse: Codable {
    let sponsors: [Sponsor]
}

class SponsorsService: ObservableObject {
    static let shared = SponsorsService()
    @Published private(set) var sponsors: [Sponsor] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let sponsorsURL = URL(string: "https://swiftgg.org/sponsors.json")!
    private let session: URLSession
    private var hasInitialLoad = false
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.timeoutIntervalForRequest = 10
        session = URLSession(configuration: config)
    }
    
    @MainActor
    func fetchSponsors() async {
        // 如果已经加载过且有数据，直接返回
        guard !hasInitialLoad || sponsors.isEmpty else { return }
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let (data, _) = try await session.data(from: sponsorsURL)
            let response = try JSONDecoder().decode(SponsorsResponse.self, from: data)
            sponsors = response.sponsors
            hasInitialLoad = true
        } catch {
            self.error = error
            print("Error fetching sponsors: \(error)")
        }
        
        isLoading = false
    }
    
    // 强制刷新方法
    @MainActor
    func forceRefresh() async {
        hasInitialLoad = false
        await fetchSponsors()
    }
} 