import SwiftUI
import AVFoundation

struct ArticleDetailView: View {
    let post: Post
    @State private var showingToast = false
    @State private var showingSettings = false
    @State private var fontSize: CGFloat = 16
    @State private var isDarkMode = false
    @State private var isFollowingSystem = true
    @Environment(\.colorScheme) var systemColorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    private var themeColor: String {
        "rgb(238, 120, 97)"
    }
    
    private var effectiveDarkMode: Bool {
        isFollowingSystem ? systemColorScheme == .dark : isDarkMode
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            WebView(htmlContent: """
                <html>
                <head>
                    <meta name='viewport' content='width=device-width, initial-scale=1'>
                    <style>
                        body {
                            font-family: -apple-system, system-ui;
                            font-size: \(fontSize)px;
                            line-height: 1.6;
                            padding: 0;
                            margin: 0 0 90px 0;
                            color: \(effectiveDarkMode ? "#FFFFFF" : "#000000");
                            background-color: \(effectiveDarkMode ? "#000000" : "#FFFFFF");
                        }
                        a {
                            color: \(themeColor);
                            text-decoration: none;
                            position: relative;
                            padding-right: 15px;
                        }
                        a::after {
                            content: '';
                            display: inline-block;
                            width: 10px;
                            height: 10px;
                            position: absolute;
                            right: 0;
                            top: 50%;
                            transform: translateY(-50%);
                            background-image: url("data:image/svg+xml;charset=utf-8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 320 512'><path fill='rgb(238, 120, 97)' d='M310.6 233.4c12.5 12.5 12.5 32.8 0 45.3l-192 192c-12.5 12.5-32.8 12.5-45.3 0s-12.5-32.8 0-45.3L242.7 256 73.4 86.6c-12.5-12.5-12.5-32.8 0-45.3s32.8-12.5 45.3 0l192 192z'/></svg>");
                            background-repeat: no-repeat;
                            background-position: center;
                            background-size: contain;
                            margin-left: 5px;
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
                            background-color: \(effectiveDarkMode ? "#1A1A1A" : "#F5F5F5");
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
            .navigationBarTitleDisplayMode(.inline)
            
            if horizontalSizeClass == .compact {  // 只在 iPhone 上显示底部工具栏
                VStack(spacing: 0) {
                    // 设置面板
                    if showingSettings {
                        VStack(spacing: 16) {
                            // 字体大小调节
                            VStack(alignment: .leading, spacing: 8) {
                                Text("字体大小")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    Image(systemName: "textformat.size.smaller")
                                        .foregroundColor(.gray)
                                    Slider(value: $fontSize, in: 12...24, step: 1)
                                    Image(systemName: "textformat.size.larger")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Divider()
                            
                            // 明暗模式切换
                            VStack(alignment: .leading, spacing: 8) {
                                Text("显示模式")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 12) {
                                    // 跟随系统
                                    Button {
                                        isFollowingSystem = true
                                        isDarkMode = systemColorScheme == .dark
                                    } label: {
                                        HStack {
                                            Image(systemName: "circle.lefthalf.filled")
                                            Text("跟随系统")
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(isFollowingSystem ? Color.accentColor : Color.gray.opacity(0.2))
                                        .foregroundColor(isFollowingSystem ? .white : .primary)
                                        .clipShape(Capsule())
                                    }
                                    
                                    // 浅色模式
                                    Button {
                                        isFollowingSystem = false
                                        isDarkMode = false
                                    } label: {
                                        HStack {
                                            Image(systemName: "sun.max.fill")
                                            Text("浅色")
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(!isFollowingSystem && !isDarkMode ? Color.accentColor : Color.gray.opacity(0.2))
                                        .foregroundColor(!isFollowingSystem && !isDarkMode ? .white : .primary)
                                        .clipShape(Capsule())
                                    }
                                    
                                    // 深色模式
                                    Button {
                                        isFollowingSystem = false
                                        isDarkMode = true
                                    } label: {
                                        HStack {
                                            Image(systemName: "moon.fill")
                                            Text("深色")
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(!isFollowingSystem && isDarkMode ? Color.accentColor : Color.gray.opacity(0.2))
                                        .foregroundColor(!isFollowingSystem && isDarkMode ? .white : .primary)
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // 底部工具栏
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            // 分享按钮
                            Button {
                                shareArticle()
                            } label: {
                                ToolbarButton(icon: "square.and.arrow.up", text: "分享")
                            }
                            
                            // 评论按钮
                            Button {
                                withAnimation {
                                    showingToast = true
                                }
                            } label: {
                                ToolbarButton(icon: "bubble.right", text: "评论")
                            }
                            
                            // 设置按钮
                            Button {
                                withAnimation(.spring()) {
                                    showingSettings.toggle()
                                }
                            } label: {
                                ToolbarButton(
                                    icon: "slider.horizontal.3",
                                    text: "设置"
                                )
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                    Color.clear
                        .frame(height: 20)
                }
                .background(Color.clear)
            } else {  // iPad/Mac 上使用导航栏按钮
                EmptyView()
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .toast(isPresented: $showingToast, message: "评论功能即将推出")
        .onAppear {
            isFollowingSystem = true
            isDarkMode = systemColorScheme == .dark
        }
        .onChange(of: systemColorScheme) { newValue in
            if isFollowingSystem {
                isDarkMode = newValue == .dark
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
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
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .interactiveDismissDisabled(false)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        )
    }
    
    // 提取分享功能
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

// 提取工具栏按钮视图
struct ToolbarButton: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .frame(width: 18)
            Text(text)
                .font(.system(size: 14))
                .lineLimit(1)
        }
        .foregroundColor(.gray)
        .frame(height: 36)
        .padding(.horizontal, 12)
    }
} 
