import Foundation

// 添加 Contributor 模型
struct Contributor: Codable, Identifiable {
    let id: String
    let name: String
    let role: String
    let url: String?
    let avatar: String?
}

// 添加响应模型
struct ContributorsResponse: Codable {
    let contributors: [Contributor]
}

class ContributorsService: ObservableObject {
    static let shared = ContributorsService()
    @Published private(set) var contributors: [Contributor] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let contributorsURL = URL(string: "https://swiftgg.org/contributors.json")!
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.timeoutIntervalForRequest = 10
        config.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                 diskCapacity: 100 * 1024 * 1024,
                                 diskPath: "contributors_cache")
        session = URLSession(configuration: config)
    }
    
    @MainActor
    func fetchContributors() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let (data, _) = try await session.data(from: contributorsURL)
            let response = try JSONDecoder().decode(ContributorsResponse.self, from: data)
            contributors = response.contributors
            
            // 预加载头像
            for contributor in contributors {
                if let avatarURLString = contributor.avatar,
                   let avatarURL = URL(string: avatarURLString) {
                    _ = try? await session.data(from: avatarURL)
                }
            }
        } catch {
            self.error = error
            print("Error fetching contributors: \(error)")
        }
        
        isLoading = false
    }
} 