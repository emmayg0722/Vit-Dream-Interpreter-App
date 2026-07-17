import SwiftUI

/// Three-tab shell: Tonight / Journal / Insights (PDD 9.2).
/// The floating glass capsule tab bar from the prototype is a TASK-002
/// design-system concern; this shell uses the system TabView until then.
struct RootTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState
        TabView(selection: $appState.selectedTab) {
            CaptureView()
                .tabItem {
                    Label("Tonight", systemImage: "moon.stars")
                }
                .tag(AppTab.tonight)

            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book")
                }
                .tag(AppTab.journal)

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar")
                }
                .tag(AppTab.insights)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RootTabView()
        .environment(AppState())
}
