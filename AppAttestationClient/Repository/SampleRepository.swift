//
//  SampleRepository.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import Foundation

struct SampleRepository {

    private var sampleAdapter: SampleAdapterProtocol
    private var attestAdapter: AppAttestAdapterProtocol

    private var attestationTask: Task<Void, Error>?

    init(
        sampleAdapter: SampleAdapterProtocol = RestSampleAdapter(apiKey: "HighlySecretAPIKey"),
        attestAdapter: AppAttestAdapterProtocol = AppAttestAdapter()
    ) {
        self.sampleAdapter = sampleAdapter
        self.attestAdapter = attestAdapter

        attestationTask = Task {
            await attestAdapter.postAttestation()
        }
    }

    func fetchSamples() async -> [Sample] {
        if attestAdapter.isSupported {
            await fetchAssertedSamples()
        } else {
            await sampleAdapter.fetchSamples()
        }
    }

    private func fetchAssertedSamples() async -> [Sample] {
        try? await attestationTask?.value

        guard let assertion = await attestAdapter.createAssertionRequest() else {
            return []
        }

        return await sampleAdapter.fetchSamples(with: assertion)
    }
}
