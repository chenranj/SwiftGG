import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard
    private let firstLaunchKey = "isFirstLaunch"
    
    var isFirstLaunch: Bool {
        get {
            defaults.object(forKey: firstLaunchKey) == nil
        }
        set {
            defaults.set(false, forKey: firstLaunchKey)
        }
    }
} 