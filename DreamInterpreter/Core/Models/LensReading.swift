import Foundation
import SwiftData

/// The six interpretive lenses (PDD 7.3).
enum Lens: String, Codable, CaseIterable {
    case zhougong
    case freud
    case jung
    case neuro
    case culture
    case spirit
}

/// One lens's take on a dream (PDD 7.3).
@Model
final class LensReading {
    var lens: Lens
    var short: String
    var full: String
    var contributed: String
    var weight: Int

    var reading: Reading?

    init(
        lens: Lens,
        short: String,
        full: String,
        contributed: String,
        weight: Int
    ) {
        self.lens = lens
        self.short = short
        self.full = full
        self.contributed = contributed
        self.weight = weight
    }
}
