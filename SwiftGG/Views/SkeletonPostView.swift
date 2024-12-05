import SwiftUI

struct SkeletonPostView: View {
    @State private var isAnimating = false
    
    // 基础颜色
    private let baseColor = Color(.systemGray6)
    // 高光颜色 - 降低透明度使效果更柔和
    private let highlightColor = Color.white.opacity(0.1)
    
    var shimmerOverlay: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: highlightColor, location: 0.4),
                            .init(color: highlightColor, location: 0.6),
                            .init(color: .clear, location: 1.0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: isAnimating)
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // 封面图骨架
            RoundedRectangle(cornerRadius: 8)
                .fill(baseColor)
                .overlay(shimmerOverlay)
                .frame(width: 120, height: 67.5)
                .clipped()
            
            // 文字内容骨架
            VStack(alignment: .leading, spacing: 8) {
                // 分类和日期骨架
                RoundedRectangle(cornerRadius: 4)
                    .fill(baseColor)
                    .overlay(shimmerOverlay)
                    .frame(width: 120, height: 12)
                    .clipped()
                
                // 标题骨架（两行）
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(baseColor)
                        .overlay(shimmerOverlay)
                        .frame(height: 16)
                        .clipped()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(baseColor)
                        .overlay(shimmerOverlay)
                        .frame(width: 140, height: 16)
                        .clipped()
                }
            }
        }
        .padding(.vertical, 8)
        .onAppear {
            isAnimating = true
        }
    }
}

// 预览
#Preview {
    SkeletonPostView()
} 