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

    init(
        sampleAdapter: SampleAdapterProtocol = RestSampleAdapter(apiKey: "HighlySecretAPIKey"),
        attestAdapter: AppAttestAdapterProtocol = AppAttestAdapter()
    ) {
        self.sampleAdapter = sampleAdapter
        self.attestAdapter = attestAdapter

        Task {
            await attestAdapter.postAttestation()
        }
    }

    func fetchSamples() async -> [Sample] {
        await sampleAdapter.fetchSamples()
    }
}
