import SwiftUI
import SafariServices

struct SwiftGuideView: View {
    @StateObject private var viewModel = SwiftGuideViewModel()
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        NavigationView {
            Group {
                if !networkMonitor.isConnected {
                    VStack(spacing: 16) {
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("连接互联网查看文档内容")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        // PDF按钮Section
                        Section {
                            Link(destination: URL(string: "https://swiftgg.team")!) {
                                HStack {
                                    Image(systemName: "giftcard")
                                        .foregroundColor(.white)
                                    Text("支持 SwiftGG 获得 PDF 版本")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15, weight: .medium))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(ThemeColors.primaryGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }
                        
                        // 文档列表
                        ForEach(viewModel.chapters) { chapter in
                            Section(chapter.title) {
                                ForEach(chapter.sections) { section in
                                    NavigationLink {
                                        WebContentView(url: URL(string: section.url)!)
                                            .navigationBarTitleDisplayMode(.inline)
                                            .ignoresSafeArea()
                                    } label: {
                                        Text(section.title)
                                    }
                                }
                            }
                        }
                        
                        // 底部按钮Section
                        Section {
                            HStack(spacing: 12) {
                                // 问题反馈按钮
                                Link(destination: URL(string: "https://github.com/SwiftGGTeam/the-swift-programming-language-in-chinese/issues")!) {
                                    HStack {
                                        Image(systemName: "ladybug.fill")
                                            .imageScale(.medium)
                                        Text("问题反馈")
                                            .font(.system(size: 15))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.secondary)
                                }
                                
                                // 加入翻译组按钮 - 使用mailto链接
                                Link(destination: URL(string: "mailto:chenran@swiftgg.org?subject=加入SwiftGG翻译组申请")!) {
                                    HStack {
                                        Image(systemName: "figure.wave")
                                            .imageScale(.medium)
                                        Text("加入翻译组")
                                            .font(.system(size: 15))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.secondary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: -8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Swift 文档")
            .navigationBarTitleDisplayMode(.large)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 90)
            }
        }
        .task {
            viewModel.loadChapters()
        }
    }
}

#Preview {
    SwiftGuideView()
}
