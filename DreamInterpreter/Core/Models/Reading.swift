import Foundation
import SwiftData

/// One opportunity-or-warning item in a reading (PDD 7.3: opportunities(kind,text)).
struct OpportunityItem: Codable, Hashable {
    enum Kind: String, Codable {
        case opportunity
        case warning
    }

    var kind: Kind
    var text: String
}

/// The interpretation of a dream (PDD 7.3).
@Model
final class Reading {
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

    var dream: Dream?

    @Relationship(deleteRule: .cascade, inverse: \LensReading.reading)
    var lenses: [LensReading]

    init(
        summary: String,
        confidence: Int,
        tones: [String] = [],
        synthesis: String,
        mainMessage: String,
        concerns: [String] = [],
        opportunities: [OpportunityItem] = [],
        questions: [String] = [],
        actions: [String] = [],
        balanceScore: Int = 0,
        lenses: [LensReading] = []
    ) {
        self.summary = summary
        self.confidence = confidence
        self.tones = tones
        self.synthesis = synthesis
        self.mainMessage = mainMessage
        self.concerns = concerns
        self.opportunities = opportunities
        self.questions = questions
        self.actions = actions
        self.balanceScore = balanceScore
        self.lenses = lenses
    }
}
