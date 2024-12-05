import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 14))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.75))
            )
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        content.overlay {
            if isPresented {
                VStack {
                    Spacer()
                    ToastView(message: message)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }
                        .padding(.bottom, 100)
                }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 2) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, duration: duration))
    }
} 