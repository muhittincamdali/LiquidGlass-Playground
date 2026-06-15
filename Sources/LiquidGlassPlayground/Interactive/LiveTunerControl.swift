import SwiftUI

/// LiquidGlass Playground: Live Parameter Tuner.
/// 
/// A world-class interface for tweaking glass parameters in real-time, 
/// optimized for professional designers and creative technologists.
public struct LiveTunerControl: View {
    @Binding var value: CGFloat
    let label: String
    let range: ClosedRange<CGFloat>
    
    public init(value: Binding<CGFloat>, label: String, range: ClosedRange<CGFloat> = 0...100) {
        self._value = value
        self.label = label
        self.range = range
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                Spacer()
                Text("\\(Int(value))")
                    .font(.caption.monospacedDigit())
            }
            Slider(value: $value, in: range)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
