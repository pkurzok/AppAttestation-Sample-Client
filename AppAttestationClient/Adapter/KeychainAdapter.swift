//
//  KeychainAdapter.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 24.01.25.
//

import Foundation
import KeychainAccess
import OSLog

// MARK: - KeychainAdapterProtocol

protocol KeychainAdapterProtocol {
    var attestationKeyId: String? { get set }
    var hasAttestationKeyId: Bool { get }
}

// MARK: - KeychainAdapter

struct KeychainAdapter: KeychainAdapterProtocol {

    private let keychain = Keychain(service: "com.peterkurzok.AppAttestationClient")

    var attestationKeyId: String? {
        get {
            read(key: .attestationKeyId)
        }
        set(value) {
            guard let value else { return }
            save(value, for: .attestationKeyId)
        }
    }

    var hasAttestationKeyId: Bool {
        has(key: .attestationKeyId)
    }

    private func has(key: KeychainKey) -> Bool {
        do {
            return try keychain.contains(KeychainKey.attestationKeyId.rawValue)
        } catch {
            Logger.keychain.error("Error reading [\(key.rawValue)]: \(error.localizedDescription)")
            return false
        }
    }

    private func save(_ value: String, for key: KeychainKey) {
        do {
            try keychain.set(value, key: KeychainKey.attestationKeyId.rawValue)
        } catch {
            Logger.keychain.error("Error saving [\(key.rawValue)]: \(error.localizedDescription)")
        }
    }

    private func read(key: KeychainKey) -> String? {
        do {
            return try keychain.get(KeychainKey.attestationKeyId.rawValue)
        } catch {
            Logger.keychain.error("Error reading [\(key.rawValue)]: \(error.localizedDescription)")
            return nil
        }
    }

    private enum KeychainKey: String {
        case attestationKeyId
    }
}
