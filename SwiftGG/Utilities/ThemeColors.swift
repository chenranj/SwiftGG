import SwiftUI

struct ThemeColors {
    static let primary = Color(red: 222/255, green: 93/255, blue: 67/255)
    
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 238/255, green: 120/255, blue: 97/255),
            Color(red: 222/255, green: 93/255, blue: 67/255)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let iconColors = IconColors()
    
    struct IconColors {
        let website = Color(red: 0/255, green: 122/255, blue: 255/255).opacity(0.95)
        let github = Color(red: 51/255, green: 51/255, blue: 51/255).opacity(0.95)
        let social = Color(red: 255/255, green: 59/255, blue: 48/255).opacity(0.95)
        let info = Color(red: 88/255, green: 86/255, blue: 214/255).opacity(0.95)
        let person = Color(red: 52/255, green: 199/255, blue: 89/255).opacity(0.95)
    }
} 
