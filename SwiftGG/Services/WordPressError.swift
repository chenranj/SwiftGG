import Foundation

enum WordPressError: Error {
    case invalidPage
    case decodingError
    case networkError(Error)
} 