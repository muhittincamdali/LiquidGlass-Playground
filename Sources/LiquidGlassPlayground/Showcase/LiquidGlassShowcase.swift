import SwiftUI

@MainActor
public struct LiquidGlassShowcase: View {
    public init() {}
    public var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack(spacing: 30) {
                Text("Liquid Glass Playground")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .frame(width: 300, height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(.white.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(radius: 20)
                
                Text("Swift 6 Purified Core")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}
