import SwiftUI
@preconcurrency import WebKit

struct WebContentView: UIViewRepresentable {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true
        
        // 设置内容边距，为导航栏和状态栏预留空间
        let topInset: CGFloat = 88  // 导航栏(44) + 状态栏(44)
        webView.scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        
        // 注入CSS来调整内容布局
        let css = """
        :root {
            --docs-hide-local-navigation: true;
        }
        body {
            padding-top: 0 !important;
            margin-top: 0 !important;
            -webkit-text-size-adjust: 100%;
        }
        header, nav {
            display: none !important;
        }
        .main-content {
            padding-top: 0 !important;
            margin-top: 0 !important;
        }
        .documentation-hero {
            display: none !important;
        }
        .navigation-title {
            display: none !important;
        }
        """
        let script = WKUserScript(
            source: "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);",
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
        webView.configuration.userContentController.addUserScript(script)
        
        // 加载URL
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebContentView
        
        init(parent: WebContentView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated {
                if navigationAction.request.url != nil {
                    decisionHandler(.allow)
                    return
                }
            }
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // 页面加载完成后再次确保样式
            let js = """
            document.body.style.paddingTop = '0';
            document.body.style.marginTop = '0';
            document.documentElement.style.setProperty('--docs-hide-local-navigation', 'true');
            Array.from(document.getElementsByTagName('header')).forEach(e => e.style.display = 'none');
            Array.from(document.getElementsByTagName('nav')).forEach(e => e.style.display = 'none');
            document.querySelector('.main-content')?.style.paddingTop = '0';
            document.querySelector('.main-content')?.style.marginTop = '0';
            document.querySelector('.documentation-hero')?.style.display = 'none';
            document.querySelector('.navigation-title')?.style.display = 'none';
            """
            webView.evaluateJavaScript(js)
        }
    }
} 
