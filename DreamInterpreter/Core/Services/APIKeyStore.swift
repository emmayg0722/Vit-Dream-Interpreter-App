import Foundation
import Security

/// Where the user's Anthropic API key lives. Q-001 interim decision: the key
/// is typed in by the user and stored in the device Keychain only — never in
/// the repo, the binary, or UserDefaults (PDD 10.2).
protocol APIKeyStoring: AnyObject {
    var apiKey: String? { get }
    @discardableResult func save(_ key: String) -> Bool
    func clear()
}

/// Keychain-backed store (generic password item). The key never appears in
/// logs or error messages.
final class KeychainAPIKeyStore: APIKeyStoring {
    private let service = "com.dreaminterpreter.anthropic-api-key"
    private let account = "anthropic"

    private var query: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
    }

    var apiKey: String? {
        var item: [String: Any] = query
        item[kSecReturnData as String] = true
        item[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        guard SecItemCopyMatching(item as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8),
              !key.isEmpty
        else { return nil }
        return key
    }

    @discardableResult
    func save(_ key: String) -> Bool {
        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            clear()
            return true
        }
        let data = Data(trimmed.utf8)

        let update = [kSecValueData as String: data]
        let updateStatus = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if updateStatus == errSecItemNotFound {
            var add = query
            add[kSecValueData as String] = data
            add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            return SecItemAdd(add as CFDictionary, nil) == errSecSuccess
        }
        return updateStatus == errSecSuccess
    }

    func clear() {
        SecItemDelete(query as CFDictionary)
    }
}

/// In-memory store for unit tests and SwiftUI previews.
final class InMemoryAPIKeyStore: APIKeyStoring {
    var apiKey: String?

    init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }

    @discardableResult
    func save(_ key: String) -> Bool {
        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
        apiKey = trimmed.isEmpty ? nil : trimmed
        return true
    }

    func clear() {
        apiKey = nil
    }
}
