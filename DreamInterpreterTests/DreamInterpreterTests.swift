import Testing
import SwiftData
@testable import DreamInterpreter

struct DreamInterpreterTests {

    /// TASK-001: the SwiftData schema must build an in-memory container
    /// and round-trip a dream with its reading and lenses.
    @Test func modelContainerRoundTrip() throws {
        let schema = Schema([Dream.self, Reading.self, LensReading.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let dream = Dream(text: "A test dream", title: "Test", symbols: ["gate"])
        let reading = Reading(
            summary: "A summary",
            confidence: 78,
            tones: ["Anticipation"],
            synthesis: "A synthesis",
            mainMessage: "A message",
            opportunities: [OpportunityItem(kind: .opportunity, text: "Pause is wisdom")],
            balanceScore: 60
        )
        reading.lenses = Lens.allCases.map { lens in
            LensReading(lens: lens, short: "s", full: "f", contributed: "c", weight: 16)
        }
        dream.reading = reading
        context.insert(dream)
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<Dream>())
        #expect(fetched.count == 1)
        #expect(fetched.first?.reading?.lenses.count == 6)
        #expect(fetched.first?.reading?.confidence == 78)
    }
}
