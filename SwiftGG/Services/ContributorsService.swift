import Foundation

// 添加 Contributor 模型
struct Contributor: Codable, Identifiable {
    let id: String
    let name: String
    let role: String
    let url: String?
    let avatar: String?
    
    // 添加一个计算属性来处理avatar URL
    var avatarURL: URL? {
        if let avatar = avatar {
            // 如果是base64数据，返回nil
            if avatar.hasPrefix("data:") {
                return nil
            }
            // 否则尝试创建URL
            return URL(string: avatar)
        }
        return nil
    }
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
    private var hasInitialLoad = false
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.timeoutIntervalForRequest = 10
        config.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                 diskCapacity: 100 * 1024 * 1024,
                                 diskPath: "contributors_cache")
        session = URLSession(configuration: config)
    }
    
    @MainActor
    func fetchContributors() async {
        // 如果已经加载过且有数据，直接返回
        guard !hasInitialLoad || contributors.isEmpty else { return }
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let (data, httpResponse) = try await session.data(from: contributorsURL)
            
            // 添加调试信息
            if let httpResponse = httpResponse as? HTTPURLResponse {
                print("Contributors API Response Status: \(httpResponse.statusCode)")
            }
            print("Contributors API Response Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
            
            let decodedResponse = try JSONDecoder().decode(ContributorsResponse.self, from: data)
            print("Decoded Contributors Count: \(decodedResponse.contributors.count)")
            for contributor in decodedResponse.contributors {
                print("Contributor ID: \(contributor.id), Name: \(contributor.name), Has Avatar: \(contributor.avatar != nil)")
            }
            
            contributors = decodedResponse.contributors
            hasInitialLoad = true
            
            // 修改预加载头像的逻辑
            for contributor in contributors {
                if let avatarURL = contributor.avatarURL {
                    print("Preloading avatar for \(contributor.name) from \(avatarURL)")
                    _ = try? await session.data(from: avatarURL)
                }
            }
        } catch {
            self.error = error
            print("Error fetching contributors: \(error.localizedDescription)")
            if let decodingError = error as? DecodingError {
                print("Decoding Error Details: \(decodingError)")
            }
        }
        
        isLoading = false
    }
    
    // 添加强制刷新方法
    @MainActor
    func forceRefresh() async {
        hasInitialLoad = false
        URLCache.shared.removeAllCachedResponses()
        await fetchContributors()
    }
} 