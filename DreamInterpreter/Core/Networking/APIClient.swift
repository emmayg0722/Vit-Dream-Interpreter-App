import Foundation

/// Minimal HTTP transport seam (PDD 4.2) so `InterpretationService` can be
/// unit-tested against canned responses without touching the network.
protocol APIClient: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

struct URLSessionAPIClient: APIClient {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, http)
    }
}
