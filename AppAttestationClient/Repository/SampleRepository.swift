//
//  SampleRepository.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import Foundation

struct SampleRepository {

    private var sampleAdapter: SampleAdapterProtocol

    init(sampleAdapter: SampleAdapterProtocol = FirebaseSampleAdapter()) {
        self.sampleAdapter = sampleAdapter
    }

    func fetchSamples() async -> [Sample] {
        await sampleAdapter.fetchSamples()
    }
}
