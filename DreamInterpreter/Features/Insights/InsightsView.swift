import SwiftUI

/// Insights tab — patterns dashboard.
/// Placeholder shell for TASK-001; aggregation and charts land in M4.
struct InsightsView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No patterns yet",
                systemImage: "chart.bar",
                description: Text("Patterns appear around 8–10 dreams.")
            )
            .navigationTitle("Insights")
        }
    }
}

#Preview {
    InsightsView()
}
