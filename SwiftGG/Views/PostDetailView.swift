import SwiftUI
import WebKit

struct PostDetailView: View {
    let post: Post
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = post.featuredMediaURL {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 200)
                    .clipped()
                    .onAppear {
                        print("Featured Media URL: \(url)")
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(post.title.rendered.removingHTMLTags())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    HStack {
                        Text(post.subCategory)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(post.timeAgo)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    WebView(htmlContent: """
                        <html>
                        <head>
                            <meta name='viewport' content='width=device-width, initial-scale=1'>
                            <style>
                                body {
                                    font-family: -apple-system, system-ui;
                                    font-size: 16px;
                                    line-height: 1.6;
                                    padding: 0;
                                    margin: 0;
                                    color: \(colorScheme == .dark ? "#FFFFFF" : "#000000");
                                    background-color: \(colorScheme == .dark ? "#000000" : "#FFFFFF");
                                }
                                img {
                                    max-width: 100%;
                                    height: auto;
                                }
                                pre {
                                    background-color: \(colorScheme == .dark ? "#1A1A1A" : "#F5F5F5");
                                    padding: 10px;
                                    border-radius: 5px;
                                    overflow-x: auto;
                                }
                                code {
                                    font-family: Menlo, Monaco, monospace;
                                }
                            </style>
                        </head>
                        <body>
                            \(post.content.rendered)
                        </body>
                        </html>
                        """)
                        .frame(minHeight: 300)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if post.featuredMediaURL == nil {
                print("No featured media URL found")
            }
        }
    }
}
