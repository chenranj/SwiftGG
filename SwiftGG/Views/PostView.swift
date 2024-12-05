import SwiftUI

struct PostView: View {
    @Environment(\.colorScheme) var colorScheme
    let post: Post
    
    var body: some View {
        HStack(spacing: 12) {
            // 封面图片
            if let url = post.featuredMediaURL {
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.3)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_):
                        Image(systemName: "photo.fill")
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(.gray.opacity(0.3))
                    @unknown default:
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(width: 120, height: 67.5)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onAppear {
                    print("Loading image from URL: \(url)")
                }
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: 120, height: 67.5)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onAppear {
                        print("No image URL found for post: \(post.id)")
                    }
            }
            
            // 文字内容
            VStack(alignment: .leading, spacing: 8) {
                Text("\(post.subCategory) · \(post.timeAgo)")
                    .font(.caption)
                    .foregroundStyle(colorScheme == .dark ? .gray : .secondary)
                
                Text(post.title.rendered)
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(2)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        .padding(.vertical, 8)
    }
} 
