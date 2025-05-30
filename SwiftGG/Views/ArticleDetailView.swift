import SwiftUI
import AVFoundation

struct ArticleDetailView: View {
    let post: Post
    @StateObject private var preferences = ReadingPreferences.shared
    @State private var showingToast = false
    @State private var showingSettings = false
    @Environment(\.colorScheme) var systemColorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                WebView(htmlContent: """
                    <html>
                    <head>
                        <meta name='viewport' content='width=device-width, initial-scale=1'>
                        <style>
                            body {
                                font-family: -apple-system, system-ui;
                                font-size: \(preferences.fontSize)px;
                                line-height: 1.6;
                                padding: 0;
                                margin: 0 0 120px 0;
                                color: \(preferences.isDarkMode ? "#FFFFFF" : "#000000");
                                background-color: \(preferences.isDarkMode ? "#000000" : "#FFFFFF");
                            }
                            a {
                                color: rgb(238, 120, 97);
                                text-decoration: none;
                            }
                            a:hover {
                                opacity: 0.8;
                            }
                            .featured-image {
                                width: 100%;
                                height: 200px;
                                object-fit: cover;
                                margin: 0;
                                padding: 0;
                            }
                            .content-wrapper {
                                padding: 16px;
                            }
                            .title {
                                font-size: 24px;
                                font-weight: bold;
                                margin: 0;
                                padding: 0;
                            }
                            .meta {
                                font-size: 14px;
                                color: #666;
                                margin: 8px 0 16px 0;
                            }
                            img {
                                max-width: 100%;
                                height: auto;
                                border-radius: 8px;
                                margin: 16px 0;
                            }
                            pre {
                                background-color: \(preferences.isDarkMode ? "#1A1A1A" : "#F5F5F5");
                                padding: 16px;
                                border-radius: 8px;
                                overflow-x: auto;
                                margin: 16px 0;
                            }
                            code {
                                font-family: Menlo, Monaco, monospace;
                            }
                            p {
                                margin: 16px 0;
                            }
                        </style>
                    </head>
                    <body>
                        \(post.featuredMediaURL.map { url in
                            "<img src='\(url)' class='featured-image'>"
                        } ?? "")
                        <div class='content-wrapper'>
                            <h1 class='title'>\(post.title.rendered.removingHTMLTags())</h1>
                            <div class='meta'>\(post.subCategory) · \(post.timeAgo)</div>
                            \(post.content.rendered)
                        </div>
                    </body>
                    </html>
                """)
                    .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("返回")
                    }
                    .foregroundColor(.accentColor)
                }
            }
            
            if horizontalSizeClass != .compact {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation(.spring()) {
                            showingSettings.toggle()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                    
                    Button {
                        withAnimation {
                            showingToast = true
                        }
                    } label: {
                        Image(systemName: "bubble.right")
                    }
                    
                    Button {
                        shareArticle()
                    } label: {
                        ToolbarButton(icon: "square.and.arrow.up", text: "分享", isDarkMode: preferences.isDarkMode)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .overlay(alignment: .bottom) {
            if horizontalSizeClass == .compact {
                VStack(spacing: 0) {
                    if showingSettings {
                        Color.black.opacity(0.001)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showingSettings = false
                                }
                            }
                        
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("字体大小")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    Image(systemName: "textformat.size.smaller")
                                        .foregroundColor(.gray)
                                    Slider(value: $preferences.fontSize, in: 12...24, step: 1)
                                    Image(systemName: "textformat.size.larger")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("显示模式")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 12) {
                                    Button {
                                        preferences.isFollowingSystem = true
                                        preferences.isDarkMode = systemColorScheme == .dark
                                    } label: {
                                        HStack {
                                            Image(systemName: "circle.lefthalf.filled")
                                            Text("跟随系统")
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(preferences.isFollowingSystem ? Color.accentColor : Color.gray.opacity(0.2))
                                        .foregroundColor(preferences.isFollowingSystem ? .white : .primary)
                                        .clipShape(Capsule())
                                    }
                                    
                                    Button {
                                        preferences.isFollowingSystem = false
                                        preferences.isDarkMode = false
                                    } label: {
                                        HStack {
                                            Image(systemName: "sun.max.fill")
                                            Text("浅色")
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(!preferences.isFollowingSystem && !preferences.isDarkMode ? Color.accentColor : Color.gray.opacity(0.2))
                                        .foregroundColor(!preferences.isFollowingSystem && !preferences.isDarkMode ? .white : .primary)
                                        .clipShape(Capsule())
                                    }
                                    
                                    Button {
                                        preferences.isFollowingSystem = false
                                        preferences.isDarkMode = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "moon.fill")
                                            Text("深色")
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(!preferences.isFollowingSystem && preferences.isDarkMode ? Color.accentColor : Color.gray.opacity(0.2))
                                        .foregroundColor(!preferences.isFollowingSystem && preferences.isDarkMode ? .white : .primary)
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Material.regular)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Button {
                                shareArticle()
                            } label: {
                                ToolbarButton(icon: "square.and.arrow.up", text: "分享", isDarkMode: preferences.isDarkMode)
                            }
                            
                            Button {
                                withAnimation {
                                    showingToast = true
                                }
                            } label: {
                                ToolbarButton(icon: "bubble.right", text: "评论", isDarkMode: preferences.isDarkMode)
                            }
                            
                            Button {
                                withAnimation(.spring()) {
                                    showingSettings.toggle()
                                }
                            } label: {
                                ToolbarButton(
                                    icon: "slider.horizontal.3",
                                    text: "设置",
                                    isDarkMode: preferences.isDarkMode
                                )
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Material.regular)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    Color.clear.frame(height: 20)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .toast(isPresented: $showingToast, message: "评论功能即将推出")
        .onAppear {
            if preferences.isFollowingSystem {
                preferences.isDarkMode = systemColorScheme == .dark
            }
        }
        .onChange(of: systemColorScheme) { _, newValue in
            if preferences.isFollowingSystem {
                preferences.isDarkMode = newValue == .dark
            }
        }
    }
    
    private func shareArticle() {
        let url = URL(string: post.link)!
        let activityVC = UIActivityViewController(
            activityItems: [
                "\(post.title.rendered) - SwiftGG",
                url
            ],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct ToolbarButton: View {
    let icon: String
    let text: String
    let isDarkMode: Bool
    @Environment(\.colorScheme) var systemColorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .frame(width: 18)
            Text(text)
                .font(.system(size: 14))
                .lineLimit(1)
        }
        .foregroundColor(systemColorScheme == .dark ? .white : .gray)
        .frame(height: 36)
        .padding(.horizontal, 12)
    }
}

struct VisualEffectView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
} 
