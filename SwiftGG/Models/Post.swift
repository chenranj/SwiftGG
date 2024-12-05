import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let title: Title
    let content: Content
    let excerpt: Excerpt?
    let date: String
    let link: String
    let categories: [Int]
    private let embedded: Embedded?
    
    var featuredMediaURL: String? {
        if let url = embedded?.wpFeaturedmedia?.first?.sourceUrl {
            return url
        }
        return nil
    }
    
    struct Title: Codable {
        let rendered: String
    }
    
    struct Content: Codable {
        let rendered: String
        let protected: Bool?
    }
    
    struct Excerpt: Codable {
        let rendered: String
        let protected: Bool?
    }
    
    struct Embedded: Codable {
        let wpFeaturedmedia: [Media]?
        let wpTerm: [[Term]]?
        
        enum CodingKeys: String, CodingKey {
            case wpFeaturedmedia = "wp:featuredmedia"
            case wpTerm = "wp:term"
        }
    }
    
    struct Media: Codable {
        let sourceUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case sourceUrl = "source_url"
        }
    }
    
    struct Term: Codable {
        let id: Int
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case excerpt
        case date
        case link
        case categories
        case embedded = "_embedded"
    }
    
    var subCategory: String {
        if let terms = embedded?.wpTerm?.first {
            if let subCategory = terms.first(where: { $0.id != 44 }) {
                return subCategory.name
            }
            if let mainCategory = terms.first {
                return mainCategory.name
            }
        }
        return "未分类"
    }
    
    var timeAgo: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        guard let date = formatter.date(from: date) else { return "" }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let year = components.year, year > 0 {
            return "\(year)年前"
        } else if let month = components.month, month > 0 {
            return "\(month)个月前"
        } else if let day = components.day, day > 0 {
            return "\(day)天前"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)小时前"
        } else if let minute = components.minute {
            return "\(max(minute, 1))分钟前"
        }
        return "刚刚"
    }
}

extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "&[^;]+;", with: "", options: .regularExpression, range: nil)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
} 