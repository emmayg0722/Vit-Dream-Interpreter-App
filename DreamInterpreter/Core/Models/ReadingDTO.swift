import Foundation

/// The AI JSON contract (PDD 7.3/ADR-004): the single source of schema truth.
/// `docs/interpretation-prompt.md` must describe exactly this shape.
struct ReadingDTO: Codable, Equatable {
    var summary: String
    var confidence: Int
    var tones: [String]
    var synthesis: String
    var mainMessage: String
    var concerns: [String]
    var opportunities: [OpportunityItem]
    var questions: [String]
    var actions: [String]
    var balanceScore: Int
    var lenses: [LensReadingDTO]
}

/// One lens's take, as decoded from the wire (PDD 7.3 `LensReading` mirror).
struct LensReadingDTO: Codable, Equatable {
    var lens: Lens
    var short: String
    var full: String
    var contributed: String
    var weight: Int
}

/// Why a decoded reading was rejected before display or persistence
/// (FR-003, PDD 10.2: all AI responses validate through `ReadingDTO`).
enum ReadingDTOError: Error, Equatable, CustomStringConvertible {
    case missingLenses(Set<Lens>)
    case duplicateLens(Lens)
    case confidenceOutOfRange(Int)
    case balanceScoreOutOfRange(Int)
    case emptyField(String)

    var description: String {
        switch self {
        case .missingLenses(let lenses):
            "Missing lenses: \(lenses.map(\.rawValue).sorted().joined(separator: ", "))"
        case .duplicateLens(let lens):
            "Duplicate lens: \(lens.rawValue)"
        case .confidenceOutOfRange(let value):
            "Confidence \(value) is outside 0...100"
        case .balanceScoreOutOfRange(let value):
            "Balance score \(value) is outside 0...100"
        case .emptyField(let field):
            "\(field) must not be empty"
        }
    }
}

extension ReadingDTO {
    /// Decodes and validates a reading in one step; normalizes lens weights
    /// to sum to exactly 100 (PDD 7.5). Throws `ReadingDTOError` on any
    /// schema or content violation so the caller can retry with feedback
    /// (FR-003, PDD 2.4).
    static func decode(from data: Data) throws -> ReadingDTO {
        var dto = try JSONDecoder().decode(ReadingDTO.self, from: data)
        try dto.validate()
        dto.normalizeWeights()
        return dto
    }

    func validate() throws {
        guard !summary.isEmpty else { throw ReadingDTOError.emptyField("summary") }
        guard !synthesis.isEmpty else { throw ReadingDTOError.emptyField("synthesis") }
        guard !mainMessage.isEmpty else { throw ReadingDTOError.emptyField("mainMessage") }
        guard (0...100).contains(confidence) else {
            throw ReadingDTOError.confidenceOutOfRange(confidence)
        }
        guard (0...100).contains(balanceScore) else {
            throw ReadingDTOError.balanceScoreOutOfRange(balanceScore)
        }

        var seen = Set<Lens>()
        for lensReading in lenses {
            guard seen.insert(lensReading.lens).inserted else {
                throw ReadingDTOError.duplicateLens(lensReading.lens)
            }
        }
        let missing = Set(Lens.allCases).subtracting(seen)
        guard missing.isEmpty else {
            throw ReadingDTOError.missingLenses(missing)
        }
    }

    /// Scales lens weights proportionally to sum to 100, using largest-remainder
    /// rounding so the contribution bar's segments still add up exactly.
    mutating func normalizeWeights() {
        let total = lenses.reduce(0) { $0 + $1.weight }
        guard total > 0, total != 100 else { return }

        let scaled = lenses.map { Double($0.weight) * 100.0 / Double(total) }
        var floors = scaled.map { Int($0) }
        var remainder = 100 - floors.reduce(0, +)

        let byRemainder = scaled.enumerated().sorted {
            ($0.element - Double(floors[$0.offset])) > ($1.element - Double(floors[$1.offset]))
        }
        var i = 0
        while remainder > 0, i < byRemainder.count {
            floors[byRemainder[i].offset] += 1
            remainder -= 1
            i += 1
        }

        for (index, weight) in floors.enumerated() {
            lenses[index].weight = weight
        }
    }
}
