import SwiftUI
import SwiftData

/// Journal tab — saved dreams list.
/// Placeholder shell for TASK-001; journal cards, reopen, and delete land in M3.
struct JournalView: View {
    @Query(sort: \Dream.createdAt, order: .reverse) private var dreams: [Dream]

    var body: some View {
        NavigationStack {
            Group {
                if dreams.isEmpty {
                    ContentUnavailableView(
                        "No dreams yet",
                        systemImage: "book",
                        description: Text("Dreams you save will appear here.")
                    )
                } else {
                    List(dreams) { dream in
                        Text(dream.title.isEmpty ? "Untitled dream" : dream.title)
                    }
                }
            }
            .navigationTitle("Dream journal")
        }
    }
}

#Preview {
    JournalView()
        .modelContainer(for: Dream.self, inMemory: true)
}
