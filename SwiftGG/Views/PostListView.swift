import SwiftUI
import SafariServices

struct PostListView: View {
    @StateObject private var viewModel = PostListViewModel()
    @Binding var hideTabBar: Bool
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        NavigationView {
            Group {
                if !networkMonitor.isConnected && viewModel.posts.isEmpty {
                    // 离线状态显示
                    VStack(spacing: 16) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("连接互联网查看最新文章")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        if viewModel.isLoading && viewModel.posts.isEmpty {
                            // 骨架屏
                            ForEach(0..<8, id: \.self) { _ in
                                SkeletonPostView()
                                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            }
                        } else {
                            ForEach(viewModel.posts) { post in
                                NavigationLink {
                                    ArticleDetailView(post: post)
                                        .onAppear { hideTabBar = true }
                                        .onDisappear { hideTabBar = false }
                                        .navigationBarTitleDisplayMode(.inline)
                                } label: {
                                    PostView(post: post)
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            }
                            
                            // 加载更多
                            if viewModel.hasMorePages {
                                HStack {
                                    Spacer()
                                    if viewModel.isLoadingMore {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                        Text("正在加载更多...")
                                    } else {
                                        Button {
                                            if networkMonitor.isConnected {
                                                Task {
                                                    await viewModel.retry()
                                                }
                                            }
                                        } label: {
                                            Text(viewModel.isLoadingFailed ? "加载失败，点击重试" : "上拉加载更多")
                                        }
                                    }
                                    Spacer()
                                }
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .frame(height: 44)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .onAppear {
                                    if !viewModel.isLoadingMore && !viewModel.isLoadingFailed && networkMonitor.isConnected {
                                        Task {
                                            await viewModel.loadMorePosts()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        if networkMonitor.isConnected {
                            await viewModel.fetchPosts()
                        }
                    }
                }
            }
            .task {
                if networkMonitor.isConnected {
                    await viewModel.checkAndLoadInitialDataIfNeeded()
                }
            }
            .navigationTitle("SwiftGG")
            .safeAreaInset(edge: .bottom) {
                if !hideTabBar {
                    Color.clear.frame(height: 90)
                }
            }
        }
    }
}

// 添加一个扩展来获取keyWindow
extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
