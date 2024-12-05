import SwiftUI
import SafariServices
import MessageUI

struct MeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @AppStorage("groceryShoppingDay") private var groceryShoppingDay = 0
    @AppStorage("skipBreakfast") private var skipBreakfast = false
    @AppStorage("skipLunch") private var skipLunch = false
    @AppStorage("skipDinner") private var skipDinner = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingDayPicker = false
    @State private var showingSafariView = false
    @State private var currentURL: URL?
    @State private var showingMailView = false
    @State private var amberText = "Amber"
    @State private var iconTapCount = 0
    @State private var showingCookieRain = false
    @State private var amberTapCount = 0
    @State private var cookieRainTimer: Timer?
    @State private var cookieRainView: CookieRainView?
    
    let daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var skippedMealsCount: Int {
        [skipBreakfast, skipLunch, skipDinner].filter { $0 }.count
    }
    
    var body: some View {
        NavigationView {
            List {
                appInfoSection
                mealSettingsSection
                generalSettingsSection
                copyrightSection
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 22))
                    }
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingDayPicker) {
            dayPickerView()
        }
        .sheet(isPresented: $showingSafariView) {
            if let url = currentURL {
                SafariView(url: url)
            }
        }
        .sheet(isPresented: $showingMailView) {
            if MailView.canSendMail {
                MailView(subject: "InchMenu Support", recipient: "support@inchmenu.com")
            }
        }
        .onAppear(perform: onAppear)
        .overlay(
            Group {
                if showingCookieRain {
                    CookieRainView()
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                showingCookieRain = false
                            }
                        }
                }
            }
        )
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
        .onChange(of: isDarkMode) { oldValue, newValue in
            setAppearance(isDark: newValue)
        }
    }
    
    private var appInfoSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                appHeaderView
                Divider()
                ForEach(appInfoItems.indices, id: \.self) { index in
                    VStack {
                        appInfoItemView(appInfoItems[index])
                        if index < appInfoItems.count - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
        .listRowBackground(sectionBackground)
    }
    
    private var appHeaderView: some View {
        HStack {
            appIcon
            appInfo
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private func appInfoItemView(_ item: AppInfoItem) -> some View {
        Button(action: { item.action() }) {
            HStack {
                Image(systemName: item.imageName)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(
                        LinearGradient(gradient: item.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(8)
                Text(item.title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
    }
    
    private struct AppInfoItem {
        let title: String
        let imageName: String
        let gradient: Gradient
        let action: () -> Void
    }
    
    private var appInfoItems: [AppInfoItem] {
        [
            AppInfoItem(title: "Homepage", imageName: "safari", gradient: Gradient(colors: [Color(red: 0.4, green: 0.6, blue: 0.9), Color(red: 0.3, green: 0.5, blue: 0.8)]), action: openHomepage),
            AppInfoItem(title: "Email Support", imageName: "envelope", gradient: Gradient(colors: [Color(red: 0.5, green: 0.8, blue: 0.5), Color(red: 0.4, green: 0.7, blue: 0.4)]), action: { showingMailView = true }),
            AppInfoItem(title: "Write a Review", imageName: "star", gradient: Gradient(colors: [Color(red: 0.9, green: 0.7, blue: 0.4), Color(red: 0.8, green: 0.6, blue: 0.3)]), action: openReview),
            AppInfoItem(title: "Privacy Policy", imageName: "hand.raised", gradient: Gradient(colors: [Color(red: 0.8, green: 0.5, blue: 0.8), Color(red: 0.7, green: 0.4, blue: 0.7)]), action: openPrivacyPolicy),
            AppInfoItem(title: "Terms of Use", imageName: "doc.text", gradient: Gradient(colors: [Color(red: 0.6, green: 0.6, blue: 0.9), Color(red: 0.5, green: 0.5, blue: 0.8)]), action: openTermsOfUse)
        ]
    }
    
    private var appIcon: some View {
        Group {
            if let lightIconImage = UIImage(named: "aboutIcon"), 
               let darkIconImage = UIImage(named: "aboutIcon-Dark") {
                Image(uiImage: isDarkMode ? darkIconImage : lightIconImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(12)
                    .onTapGesture(perform: iconTapped)
            } else {
                Image(systemName: "app.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(isDarkMode ? .white : .blue)
                    .cornerRadius(12)
                    .onTapGesture(perform: iconTapped)
            }
        }
    }
    
    private var appInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("CookMonster")
                .font(.headline)
            Text("Version 0.0.1")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    private var mealSettingsSection: some View {
        Section(header: Text("Meal Settings")) {
            settingRow(title: "Grocery day", imageName: "cart", gradient: Gradient(colors: [Color(red: 0.5, green: 0.8, blue: 0.5), Color(red: 0.4, green: 0.7, blue: 0.4)])) {
                HStack {
                    Spacer()
                    Button(daysOfWeek[groceryShoppingDay]) {
                        showingDayPicker = true
                    }
                    .foregroundColor(.blue)
                }
            }
            
            toggleRow(title: "Skip Breakfast", imageName: "sunrise", gradient: Gradient(colors: [Color(red: 0.9, green: 0.7, blue: 0.4), Color(red: 0.8, green: 0.6, blue: 0.3)]), isOn: $skipBreakfast)
                .disabled(skippedMealsCount >= 2 && !skipBreakfast)
            
            toggleRow(title: "Skip Lunch", imageName: "sun.max", gradient: Gradient(colors: [Color(red: 0.7, green: 0.8, blue: 0.4), Color(red: 0.6, green: 0.7, blue: 0.3)]), isOn: $skipLunch)
                .disabled(skippedMealsCount >= 2 && !skipLunch)
            
            toggleRow(title: "Skip Dinner", imageName: "moon", gradient: Gradient(colors: [Color(red: 0.5, green: 0.7, blue: 0.9), Color(red: 0.4, green: 0.6, blue: 0.8)]), isOn: $skipDinner)
                .disabled(skippedMealsCount >= 2 && !skipDinner)
        }
        .listRowBackground(sectionBackground)
    }
    
    private var generalSettingsSection: some View {
        Section(header: Text("General Settings")) {
            toggleRow(title: "Dark Mode", imageName: "moon.stars", gradient: Gradient(colors: [Color(red: 0.4, green: 0.6, blue: 0.9), Color(red: 0.3, green: 0.5, blue: 0.8)]), isOn: $isDarkMode)
        }
        .listRowBackground(sectionBackground)
    }
    
    private var copyrightSection: some View {
        Section {
            VStack(alignment: .center, spacing: 4) {
                Text("Copyright © InchMenu.com")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                HStack(spacing: 0) {
                    Text("Made with ♥️ in Boston for ")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text(amberText)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .onTapGesture {
                            amberTapped()
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
        }
    }
    
    private func dayPickerView() -> some View {
        VStack {
            Picker("Grocery day", selection: $groceryShoppingDay) {
                ForEach(0..<7) { index in
                    Text(daysOfWeek[index]).tag(index)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Button("Done") {
                showingDayPicker = false
            }
            .padding()
        }
        .presentationDetents([.height(250)])
    }
    
    private func onAppear() {
        isDarkMode = colorScheme == .dark
    }
    
    private func setAppearance(isDark: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
        
        // 使用 AppStorage 来触发视图更新
        isDarkMode = isDark
    }
    
    private func iconTapped() {
        iconTapCount += 1
        
        // 每次点击都震动
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        if iconTapCount == 10 {
            showingCookieRain = true
            iconTapCount = 0
        }
    }
    
    private func openHomepage() {
        currentURL = URL(string: "https://inchmenu.com")
        showingSafariView = true
    }
    
    private func openReview() {
        if let writeReviewURL = URL(string: "https://apps.apple.com/app/id<YOUR_APP_ID>?action=write-review") {
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
    
    private func openPrivacyPolicy() {
        currentURL = URL(string: "https://inchmenu.com/privacy")
        showingSafariView = true
    }
    
    private func openTermsOfUse() {
        currentURL = URL(string: "https://inchmenu.com/terms")
        showingSafariView = true
    }
    
    private func amberTapped() {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        amberText = "👧🏻"
        openInstagram()
    }
    
    private func openInstagram() {
        if let instagramURL = URL(string: "instagram://user?username=_soberamber_") {
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else if let webInstagramURL = URL(string: "https://www.instagram.com/_soberamber_") {
            UIApplication.shared.open(webInstagramURL, options: [:], completionHandler: nil)
        }
    }
    
    private func settingRow<Content: View>(title: String, imageName: String, gradient: Gradient, @ViewBuilder content: () -> Content) -> some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(
                    LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(8)
            Text(title)
            Spacer()
            content()
        }
    }
    
    private func toggleRow(title: String, imageName: String, gradient: Gradient, isOn: Binding<Bool>) -> some View {
        settingRow(title: title, imageName: imageName, gradient: gradient) {
            Toggle("", isOn: isOn)
        }
    }
    
    // 添加这个计算属性来设置section背景色
    private var sectionBackground: Color {
        isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
    }
}

struct CookieRainView: View {
    let cookieEmoji = "🍪"
    let cookieCount = 30
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<cookieCount, id: \.self) { index in
                CookieView(cookieEmoji: cookieEmoji, size: geometry.size, delay: Double(index) * 0.1)
            }
        }
    }
}

struct CookieView: View {
    let cookieEmoji: String
    let size: CGSize
    let delay: Double
    
    @State private var yPosition: CGFloat
    @State private var xPosition: CGFloat
    @State private var opacity: Double = 0
    
    init(cookieEmoji: String, size: CGSize, delay: Double) {
        self.cookieEmoji = cookieEmoji
        self.size = size
        self.delay = delay
        
        _yPosition = State(initialValue: -50)
        _xPosition = State(initialValue: CGFloat.random(in: 0...size.width))
    }
    
    var body: some View {
        Text(cookieEmoji)
            .font(.system(size: 30))
            .position(x: xPosition, y: yPosition)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation.easeIn(duration: 0.5).delay(delay)) {
                    self.opacity = 1
                }
                withAnimation(Animation.linear(duration: Double.random(in: 3...6)).delay(delay).repeatForever(autoreverses: false)) {
                    yPosition = size.height + 50
                }
            }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

struct MailView: UIViewControllerRepresentable {
    let subject: String
    let recipient: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setSubject(subject)
        vc.setToRecipients([recipient])
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
}

// 添加这个扩展来获取应用程序图标
extension UIApplication {
    var icon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
            return nil
        }
        return UIImage(named: lastIcon)
    }
}

extension View {
    func colorInvert(_ shouldInvert: Bool) -> some View {
        self.colorInvert().opacity(shouldInvert ? 1 : 0)
    }
}

#Preview {
    MeView()
}
