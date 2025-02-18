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
    func createAssertionRequest() async -> AssertionRequest?
    func postAttestation() async

    var isSupported: Bool { get }
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
    }

    var isSupported: Bool {
        service.isSupported
    }

    func postAttestation() async {
        await generateKeyIfNeeded()

        guard service.isSupported else {
            Logger.attestation.error("Attestation not supported")
            return
        }

        guard let keyId = keychain.attestationKeyId else {
            Logger.attestation.error("No KeyId found, aborting!")
            return
        }

        guard let challenge = await fetchChallenge() else {
            Logger.attestation.error("Couldn't fetch Challenge, aborting!")
            return
        }

        let hash = Data(SHA256.hash(data: challenge.data))

        do {
            let attestKey = try await service.attestKey(keyId, clientDataHash: hash)
            Logger.attestation.log("Received Attestation: \(attestKey.debugDescription)")

            await postAttestationKey(attestKey, keyId: keyId, challengeId: challenge.id)

            Logger.attestation.log("Successfully validated Attestation")
        } catch {
            Logger.attestation.error("Error for Attestation: \(error.localizedDescription)")
        }
    }

    func createAssertionRequest() async -> AssertionRequest? {
        guard service.isSupported else {
            Logger.attestation.error("Attestation not supported")
            return nil
        }

        guard let keyId = keychain.attestationKeyId,
              let keyIdData = Data(base64Encoded: keyId)
        else {
            Logger.attestation.error("No KeyId found, aborting!")
            return nil
        }

        guard let challenge = await fetchChallenge() else {
            Logger.attestation.error("Couldn't fetch Challenge, aborting!")
            return nil
        }

        let hash = Data(SHA256.hash(data: challenge.data))

        do {
            let assertion = try await service.generateAssertion(keyId, clientDataHash: hash)
            return AssertionRequest(
                assertion: assertion,
                keyID: keyIdData,
                challengeID: challenge.id,
                clientData: Data()
            )
        } catch {
            Logger.attestation.error("Error generation Assertion: \(error.localizedDescription)")
            return nil
        }
    }

    private func postAttestationKey(_ key: Data, keyId: String, challengeId: UUID) async {
        guard let keyIdData = Data(base64Encoded: keyId)
        else {
            Logger.attestation.error("Couldn't convert KeyId to Data, aborting!")
            return
        }
        guard let url = URL(string: "\(baseUrl)/attestation") else { return }

        let req = AttestationRequest(
            attestation: key,
            keyID: keyIdData,
            challengeID: challengeId
        )

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(req)

        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        do {
            let (_, response) = try await urlSession.data(for: urlRequest)
            Logger.attestation.debug("Got response: \(response.debugDescription)")
        } catch {
            Logger.attestation.error("Error posting Attestation: \(error.localizedDescription)")
        }
    }

    private func fetchChallenge() async -> Challenge? {
        guard let url = URL(string: "\(baseUrl)/challenge") else { return nil }

        do {
            let (data, _) = try await urlSession.data(from: url)
            let challenge = try JSONDecoder().decode(Challenge.self, from: data)
            Logger.attestation.debug("Fetched Challenge with ID: \(challenge.id)")
            return challenge
        } catch {
            Logger.attestation.error("Error fetching Challenge: \(error.localizedDescription)")
            return nil
        }
    }

    private func generateKeyIfNeeded() async {
        guard keychain.hasAttestationKeyId == false else { return }

        Logger.attestation.log("No Attestation KeyId found in Keychain. Generating new one...")
        await generateKey()
    }

    private func generateKey() async {
        guard service.isSupported else {
            Logger.attestation.error("Attestation not supported")
            return
        }

        do {
            let keyId = try await service.generateKey()
            keychain.attestationKeyId = keyId
            Logger.attestation.log("... did generate Attestation KeyId: \(keyId)")
        } catch {
            Logger.attestation.error("Error generating Attestation Key: \(error.localizedDescription)")
        }
    }
}
