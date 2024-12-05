import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") private(set) var isDarkMode = false
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
} 