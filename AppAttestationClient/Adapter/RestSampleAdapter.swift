//
//  RestSampleAdapter.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import FirebaseAppCheck
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
        baseUrl: String = "http://localhost:8080"
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
        get async {
            let url = URL(string: "\(baseUrl)/samples")!
            return await authenticatedRequest(for: url)
        }
    }

    private func authenticatedRequest(for url: URL) async -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "apiKey")
        do {
            try await request.setValue(appCheckToken, forHTTPHeaderField: "X-Firebase-AppCheck")
        } catch {
            Logger.sampleApi.error("Error setting AppCheck token: \(error.localizedDescription)")
        }
        return request
    }

    private var appCheckToken: String {
        get async throws {
            try await AppCheck.appCheck().token(forcingRefresh: false).token
            // try await AppCheck.appCheck().limitedUseToken().token
        }
    }
}
