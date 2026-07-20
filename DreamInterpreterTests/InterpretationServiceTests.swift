import Testing
import Foundation
@testable import DreamInterpreter

/// FR-003: request building, envelope parsing, validation through
/// `ReadingDTO.decode`, retry-on-invalid with feedback, and typed errors.
/// No test here touches the network or the Keychain.
struct InterpretationServiceTests {

    private let dream = "A long swim through a glowing green sea."

    private func makeService(
        client: MockAPIClient,
        apiKey: String? = "sk-test"
    ) -> InterpretationService {
        InterpretationService(apiClient: client, keyStore: InMemoryAPIKeyStore(apiKey: apiKey))
    }

    private func fixtureJSON() -> String {
        String(data: try! JSONEncoder().encode(SampleDream.reading), encoding: .utf8)!
    }

    /// Wraps reply text in the Anthropic Messages response envelope.
    private func envelope(_ text: String) -> Data {
        let object: [String: Any] = ["content": [["type": "text", "text": text]]]
        return try! JSONSerialization.data(withJSONObject: object)
    }

    @Test func successDecodesReading() async throws {
        let client = MockAPIClient(responses: [(200, envelope(fixtureJSON()))])
        let service = makeService(client: client)

        let reading = try await service.interpret(dreamText: dream)

        #expect(reading == SampleDream.reading)
        #expect(client.requests.count == 1)

        let request = try #require(client.requests.first)
        #expect(request.url?.absoluteString == "https://api.anthropic.com/v1/messages")
        #expect(request.value(forHTTPHeaderField: "x-api-key") == "sk-test")
        #expect(request.value(forHTTPHeaderField: "anthropic-version") != nil)
        let body = String(data: try #require(request.httpBody), encoding: .utf8)!
        #expect(body.contains(dream))
        #expect(body.contains(InterpretationService.model))
    }

    /// The model is told to reply with raw JSON, but fences or prose around
    /// the object must not break decoding.
    @Test func fencedJSONIsTolerated() async throws {
        let fenced = "```json\n\(fixtureJSON())\n```"
        let client = MockAPIClient(responses: [(200, envelope(fenced))])

        let reading = try await makeService(client: client).interpret(dreamText: dream)

        #expect(reading == SampleDream.reading)
    }

    /// PDD 2.4: malformed reading → one automatic retry with the validation
    /// error fed back, then success.
    @Test func invalidReadingRetriesOnceWithFeedback() async throws {
        var invalid = SampleDream.reading
        invalid.confidence = 150
        let invalidJSON = String(data: try JSONEncoder().encode(invalid), encoding: .utf8)!
        let client = MockAPIClient(responses: [
            (200, envelope(invalidJSON)),
            (200, envelope(fixtureJSON())),
        ])

        let reading = try await makeService(client: client).interpret(dreamText: dream)

        #expect(reading == SampleDream.reading)
        #expect(client.requests.count == 2)
        let retryBody = String(data: try #require(client.requests.last?.httpBody), encoding: .utf8)!
        #expect(retryBody.contains("failed validation"))
        #expect(retryBody.contains("150"))
    }

    @Test func invalidReadingTwiceFails() async throws {
        let client = MockAPIClient(responses: [
            (200, envelope("not json at all")),
            (200, envelope("still not json")),
        ])

        await #expect(throws: InterpretationError.self) {
            try await makeService(client: client).interpret(dreamText: dream)
        }
        #expect(client.requests.count == 2)
    }

    @Test func missingKeyFailsWithoutRequest() async {
        let client = MockAPIClient(responses: [])

        await #expect(throws: InterpretationError.missingAPIKey) {
            try await makeService(client: client, apiKey: nil).interpret(dreamText: dream)
        }
        #expect(client.requests.isEmpty)
    }

    @Test(arguments: [
        (401, InterpretationError.unauthorized),
        (429, InterpretationError.rateLimited),
        (500, InterpretationError.serverUnavailable),
        (529, InterpretationError.serverUnavailable),
    ])
    func httpStatusMapsToTypedError(status: Int, expected: InterpretationError) async {
        let client = MockAPIClient(responses: [(status, Data())])

        await #expect(throws: expected) {
            try await makeService(client: client).interpret(dreamText: dream)
        }
    }

    @Test func transportFailureMapsToOffline() async {
        let client = MockAPIClient(error: URLError(.notConnectedToInternet))

        await #expect(throws: InterpretationError.offline) {
            try await makeService(client: client).interpret(dreamText: dream)
        }
    }
}

/// Canned transport: returns queued (status, body) pairs in order, or throws.
final class MockAPIClient: APIClient, @unchecked Sendable {
    private let lock = NSLock()
    private var responses: [(Int, Data)]
    private let error: Error?
    private(set) var requests: [URLRequest] = []

    init(responses: [(Int, Data)]) {
        self.responses = responses
        self.error = nil
    }

    init(error: Error) {
        self.responses = []
        self.error = error
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        lock.lock()
        defer { lock.unlock() }
        requests.append(request)
        if let error { throw error }
        guard !responses.isEmpty else {
            throw URLError(.badServerResponse)
        }
        let (status, data) = responses.removeFirst()
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: status,
            httpVersion: nil,
            headerFields: nil
        )!
        return (data, response)
    }
}
