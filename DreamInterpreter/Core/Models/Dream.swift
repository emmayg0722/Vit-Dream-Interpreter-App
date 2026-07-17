import Foundation
import SwiftData

/// A captured dream (PDD 7.3).
@Model
final class Dream {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var text: String
    var title: String
    var symbols: [String]

    @Relationship(deleteRule: .cascade, inverse: \Reading.dream)
    var reading: Reading?

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        text: String,
        title: String = "",
        symbols: [String] = [],
        reading: Reading? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.text = text
        self.title = title
        self.symbols = symbols
        self.reading = reading
    }
}
