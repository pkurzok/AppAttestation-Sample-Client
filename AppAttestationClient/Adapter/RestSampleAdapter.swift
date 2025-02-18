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
        baseUrl: String = InfoPlistAdapter.baseUrl
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

    func fetchSamples(with assertion: AssertionRequest) async -> [Sample] {
        let request = createAssertedSamplesRequest(with: assertion)

        do {
            let (data, _) = try await urlSession.data(for: request)
            let samples = try decoder.decode([Sample].self, from: data)
            Logger.sampleApi.log("Fetched \(samples.count) Asserted Samples")

            return samples
        } catch {
            Logger.sampleApi.error("Error fetching Samples: \(error.localizedDescription)")
            return []
        }
    }

    private func createAssertedSamplesRequest(with assertion: AssertionRequest) -> URLRequest {
        let url = URL(string: "\(baseUrl)/asserted-samples")!
        let sampleRequest = SamplesRequest(assertionRequest: assertion)
        var authenticatedRequest = authenticatedRequest(for: url)
        authenticatedRequest.httpMethod = "POST"
        authenticatedRequest.httpBody = try? JSONEncoder().encode(sampleRequest)
        authenticatedRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        return authenticatedRequest
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
