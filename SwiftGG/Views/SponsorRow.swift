import SwiftUI

struct SponsorRow: View {
    let sponsor: Sponsor
    
    var body: some View {
        Link(destination: URL(string: sponsor.websiteURL)!) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: sponsor.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                }
                .frame(width: 120, height: 67.5)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text(sponsor.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
} 