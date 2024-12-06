import Foundation

class ReadingPreferences: ObservableObject {
    static let shared = ReadingPreferences()
    
    @Published var fontSize: CGFloat {
        didSet {
            UserDefaults.standard.set(fontSize, forKey: "reading_font_size")
        }
    }
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "reading_dark_mode")
        }
    }
    
    @Published var isFollowingSystem: Bool {
        didSet {
            UserDefaults.standard.set(isFollowingSystem, forKey: "reading_follow_system")
        }
    }
    
    private init() {
        // 从 UserDefaults 读取保存的设置，如果没有则使用默认值
        self.fontSize = UserDefaults.standard.object(forKey: "reading_font_size") as? CGFloat ?? 16
        self.isDarkMode = UserDefaults.standard.bool(forKey: "reading_dark_mode")
        self.isFollowingSystem = UserDefaults.standard.object(forKey: "reading_follow_system") as? Bool ?? true
    }
} 