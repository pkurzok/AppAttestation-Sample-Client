//
//  AppAttestAdapter.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 24.01.25.
//

import CryptoKit
import DeviceCheck
import Foundation
import OSLog

// MARK: - AppAttestAdapterProtocol

protocol AppAttestAdapterProtocol {
    func attestation() async -> Data?
    func attestAssertion() async -> Data?
}

// MARK: - AppAttestAdapter

class AppAttestAdapter: AppAttestAdapterProtocol {
    private let service: DCAppAttestService
    private var keychain: KeychainAdapterProtocol

    private let urlSession: URLSession
    private let baseUrl: String

    init(
        attestService: DCAppAttestService = .shared,
        keychain: KeychainAdapterProtocol = KeychainAdapter(),
        urlSession: URLSession = URLSession.shared,
        baseUrl: String = InfoPlistAdapter.baseUrl
    ) {
        self.service = attestService
        self.keychain = keychain
        self.urlSession = urlSession
        self.baseUrl = baseUrl

        generateKeyIfNeeded()
    }

    func attestation() async -> Data? {
        guard service.isSupported else {
            Logger.attestation.error("Attestation not supported")
            return nil
        }

        guard let challenge = await fetchChallenge(),
              let challengeData = challenge.data(using: .utf8) else {
            Logger.attestation.error("Couldn't fetch Challenge, aborting!")
            return nil
        }

        guard let keyId = keychain.attestationKeyId else {
            Logger.attestation.error("No KeyId found, aborting!")
            return nil
        }
        let hash = Data(SHA256.hash(data: challengeData))

        do {
            let attestKey = try await service.attestKey(keyId, clientDataHash: hash)
            Logger.attestation.debug("Received Attestation: \(attestKey.debugDescription)")
            return attestKey
        } catch {
            Logger.attestation.error("Error for Attestation: \(error.localizedDescription)")
            return nil
        }
    }

    func attestAssertion() async -> Data? {
        guard let challenge = await fetchChallenge(),
              let challengeData = challenge.data(using: .utf8) else {
            Logger.attestation.error("Couldn't fetch Challenge, aborting!")
            return nil
        }

        guard let keyId = keychain.attestationKeyId else {
            Logger.attestation.error("No KeyId found, aborting!")
            return nil
        }
        let hash = Data(SHA256.hash(data: challengeData))

        do {
            return try await service.generateAssertion(keyId, clientDataHash: hash)
        } catch {
            Logger.attestation.error("Error generation Assertion: \(error.localizedDescription)")
            return nil
        }
    }

    private func fetchChallenge() async -> String? {
        guard let url = URL(string: "\(baseUrl)/challenge") else { return nil }

        do {
            let (data, _) = try await urlSession.data(from: url)

            guard let challenge = String(data: data, encoding: .utf8) else { return nil }
            Logger.attestation.debug("Fetched Challenge: \(challenge)")
            return challenge
        } catch {
            Logger.attestation.error("Error fetching Challenge: \(error.localizedDescription)")
            return nil
        }
    }

    private func generateKeyIfNeeded() {
        guard keychain.hasAttestationKeyId == false else { return }

        Logger.attestation.log("No Attestation KeyId found in Keychain. Generating new one...")
        generateKey()
    }

    private func generateKey() {
        guard service.isSupported else {
            Logger.attestation.error("Attestation not supported")
            return
        }
        service.generateKey { keyId, error in
            guard error == nil else {
                Logger.attestation.error("Error generating Attestation Key: \(error?.localizedDescription ?? "")")
                return
            }

            if let keyId {
                self.keychain.attestationKeyId = keyId
                Logger.attestation.log("... did generate Attestation KeyId: \(keyId)")
            }
        }
    }
}
