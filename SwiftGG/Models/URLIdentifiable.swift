import Foundation

struct URLIdentifiable: Identifiable {
    let url: URL
    var id: String { url.absoluteString }
} 