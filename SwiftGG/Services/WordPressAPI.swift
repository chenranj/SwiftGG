import Foundation

class WordPressAPI {
    static let shared = WordPressAPI()
    private let baseURL = "https://swiftgg.org/wp-json/wp/v2/posts"
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.tlsMinimumSupportedProtocolVersion = .TLSv12
        config.tlsMaximumSupportedProtocolVersion = .TLSv13
        config.allowsExpensiveNetworkAccess = true
        config.allowsConstrainedNetworkAccess = true
        config.waitsForConnectivity = true
        
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Accept-Language": "zh-CN,zh;q=0.9",
            "Connection": "keep-alive"
        ]
        
        session = URLSession(configuration: config)
    }
    
    enum Error: Swift.Error {
        case networkError
        case serverError(Int)
        case decodingError
        case invalidPage
        case noMorePages
    }
    
    func fetchPosts(page: Int = 1) async throws -> (posts: [Post], hasMore: Bool) {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "categories", value: "44"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "_embed", value: "true")
        ]
        
        let url = components.url!
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw Error.networkError
            }
            
            if httpResponse.statusCode == 400 {
                throw Error.noMorePages
            }
            
            guard httpResponse.statusCode == 200 else {
                throw Error.serverError(httpResponse.statusCode)
            }
            
            let posts = try JSONDecoder().decode([Post].self, from: data)
            
            let totalPages = Int(httpResponse.value(forHTTPHeaderField: "X-WP-TotalPages") ?? "1") ?? 1
            let hasMore = page < totalPages && !posts.isEmpty
            
            return (posts: posts, hasMore: hasMore)
        } catch let error as Error {
            throw error
        } catch {
            print("Unexpected error: \(error)")
            throw Error.decodingError
        }
    }
}

// 添加错误描述
extension WordPressAPI.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "网络连接错误"
        case .serverError(let code):
            return "服务器错误 (\(code))"
        case .decodingError:
            return "数据解析错误"
        case .invalidPage:
            return "无效的页码"
        case .noMorePages:
            return "没有更多内容"
        }
    }
} 
