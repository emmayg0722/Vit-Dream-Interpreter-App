import Testing
import Foundation
@testable import DreamInterpreter

struct ReadingDTOTests {

    private func encode(_ dto: ReadingDTO) throws -> Data {
        try JSONEncoder().encode(dto)
    }

    @Test func sampleFixtureRoundTripsAndValidates() throws {
        let data = try encode(SampleDream.reading)
        let decoded = try ReadingDTO.decode(from: data)
        #expect(decoded == SampleDream.reading)
    }

    @Test func sampleFixtureWeightsSumTo100() {
        let total = SampleDream.reading.lenses.reduce(0) { $0 + $1.weight }
        #expect(total == 100)
    }

    @Test func decodeRejectsMissingLens() throws {
        var dto = SampleDream.reading
        dto.lenses.removeLast()
        let data = try encode(dto)
        #expect(throws: ReadingDTOError.self) {
            try ReadingDTO.decode(from: data)
        }
    }

    @Test func decodeRejectsDuplicateLens() throws {
        var dto = SampleDream.reading
        dto.lenses[1].lens = dto.lenses[0].lens
        let data = try encode(dto)
        #expect(throws: ReadingDTOError.self) {
            try ReadingDTO.decode(from: data)
        }
    }

    @Test func decodeRejectsOutOfRangeConfidence() throws {
        var dto = SampleDream.reading
        dto.confidence = 140
        let data = try encode(dto)
        #expect(throws: ReadingDTOError.self) {
            try ReadingDTO.decode(from: data)
        }
    }

    @Test func decodeRejectsEmptySummary() throws {
        var dto = SampleDream.reading
        dto.summary = ""
        let data = try encode(dto)
        #expect(throws: ReadingDTOError.self) {
            try ReadingDTO.decode(from: data)
        }
    }

    @Test func decodeNormalizesUnevenWeightsTo100() throws {
        var dto = SampleDream.reading
        // Perturb weights so the raw sum is 94, not 100.
        dto.lenses[0].weight = 8
        let data = try encode(dto)
        let decoded = try ReadingDTO.decode(from: data)
        let total = decoded.lenses.reduce(0) { $0 + $1.weight }
        #expect(total == 100)
    }

    @Test func malformedJSONFailsToDecode() {
        let data = Data("{ not valid json".utf8)
        #expect(throws: Error.self) {
            try ReadingDTO.decode(from: data)
        }
    }
}
