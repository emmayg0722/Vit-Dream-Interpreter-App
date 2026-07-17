import SwiftUI

/// Small uppercase section header used throughout the reading screen
/// (prototype `SectionLabel`).
struct SectionLabel: View {
    var text: String

    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .tracking(1.4)
            .foregroundStyle(Tokens.inkFaint)
    }
}

/// One bullet line in "Possible subconscious concerns".
struct ConcernRow: View {
    var text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(Tokens.rose)
                .frame(width: 5, height: 5)
                .padding(.top, 7)
            Text(text)
                .font(.system(size: 13.5))
                .foregroundStyle(Tokens.inkSoft)
                .lineSpacing(3)
        }
    }
}

/// One row in "Opportunities & warnings" (prototype OPEN/WATCH tags).
struct OpportunityRow: View {
    var item: OpportunityItem

    private var isOpportunity: Bool { item.kind == .opportunity }
    private var tintColor: Color { isOpportunity ? Tokens.teal : Tokens.rose }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(isOpportunity ? "OPEN" : "WATCH")
                .font(.system(size: 10, weight: .bold))
                .tracking(0.8)
                .foregroundStyle(tintColor)
                .padding(.top, 3)
            Text(item.text)
                .font(.system(size: 13.5))
                .foregroundStyle(Tokens.ink)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(tintColor.opacity(0.10), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(tintColor.opacity(0.30), lineWidth: 1)
        )
    }
}

/// One numbered row in "Gentle actions".
struct ActionRow: View {
    var index: Int
    var text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(index)")
                .font(.system(size: 11.5, weight: .bold))
                .foregroundStyle(Tokens.lavender)
                .frame(width: 24, height: 24)
                .background(Tokens.lavender.opacity(0.16), in: Circle())
                .overlay(Circle().strokeBorder(Tokens.lavender.opacity(0.35), lineWidth: 1))
            Text(text)
                .font(.system(size: 13.5))
                .foregroundStyle(Tokens.inkSoft)
                .lineSpacing(3)
        }
    }
}
