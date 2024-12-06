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
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.timeoutIntervalForRequest = 10
        session = URLSession(configuration: config)
    }
    
    @MainActor
    func fetchSponsors() async {
        guard !hasInitialLoad || sponsors.isEmpty else { 
            print("Skipping fetch due to hasInitialLoad: \(hasInitialLoad), sponsors count: \(sponsors.count)")
            return 
        }
        guard !isLoading else { 
            print("Skipping fetch due to isLoading")
            return 
        }
        
        isLoading = true
        error = nil
        
        do {
            print("Fetching sponsors from: \(sponsorsURL)")
            let (data, httpResponse) = try await session.data(from: sponsorsURL)
            
            if let httpResponse = httpResponse as? HTTPURLResponse {
                print("Sponsors API Response Status: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            }
            
            let jsonString = String(data: data, encoding: .utf8) ?? "Unable to decode"
            print("Raw Response Data: \(jsonString)")
            
            let decodedResponse = try JSONDecoder().decode(SponsorsResponse.self, from: data)
            print("Successfully decoded response with \(decodedResponse.sponsors.count) sponsors")
            
            for sponsor in decodedResponse.sponsors {
                print("""
                    Sponsor Details:
                    - ID: \(sponsor.id)
                    - Name: \(sponsor.name)
                    - Level: \(sponsor.level.rawValue)
                    - Image URL: \(sponsor.imageURL)
                    - Website URL: \(sponsor.websiteURL)
                    """)
            }
            
            sponsors = decodedResponse.sponsors
            hasInitialLoad = true
            print("Updated sponsors array with \(sponsors.count) items")
            
        } catch {
            self.error = error
            print("Error fetching sponsors: \(error.localizedDescription)")
            if let decodingError = error as? DecodingError {
                print("Decoding Error Details: \(decodingError)")
            }
        }
        
        isLoading = false
    }
    
    @MainActor
    func forceRefresh() async {
        hasInitialLoad = false
        URLCache.shared.removeAllCachedResponses()
        await fetchSponsors()
    }
} 