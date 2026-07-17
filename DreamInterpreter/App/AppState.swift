import SwiftUI

/// Tabs of the root shell (PDD 9.2: Tonight / Journal / Insights).
enum AppTab: Hashable {
    case tonight
    case journal
    case insights
}

/// App-wide UI state shared across features.
@Observable
final class AppState {
    var selectedTab: AppTab = .tonight
}
