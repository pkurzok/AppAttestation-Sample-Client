//
//  RestSampleAdapter.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import Foundation
import OSLog

struct RestSampleAdapter: SampleAdapterProtocol {
    private let decoder = JSONDecoder()

    private let urlSession: URLSession
    private let apiKey: String
    private let baseUrl: String

    init(
        apiKey: String,
        urlSession: URLSession = URLSession.shared,
        baseUrl: String = "http://127.0.0.1:8080"
    ) {
        self.apiKey = apiKey
        self.urlSession = urlSession
        self.baseUrl = baseUrl
    }

    func fetchSamples() async -> [Sample] {
        do {
            let (data, _) = try await urlSession.data(for: samplesRequest)
            let samples = try decoder.decode([Sample].self, from: data)
            Logger.sampleApi.log("Fetched \(samples.count) Samples")

            return samples
        } catch {
            Logger.sampleApi.error("Error fetching Samples: \(error.localizedDescription)")
            return []
        }
    }

    private var samplesRequest: URLRequest {
        let url = URL(string: "\(baseUrl)/samples")!
        return authenticatedRequest(for: url)
    }

    private func authenticatedRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "apiKey")
        return request
    }
}
