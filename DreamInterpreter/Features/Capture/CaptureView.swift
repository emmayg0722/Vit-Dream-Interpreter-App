import SwiftUI

/// Tonight tab — dream capture screen.
/// Placeholder shell for TASK-001; full capture UI with draft persistence
/// lands in TASK-004 against the TASK-002 design system.
struct CaptureView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "moon.stars")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
                Text("Good morning. What did you dream last night?")
                    .fontDesign(.serif)
                    .multilineTextAlignment(.center)
                Text("Reflections, not predictions · For self-exploration only")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Tonight")
        }
    }
}

#Preview {
    CaptureView()
}
