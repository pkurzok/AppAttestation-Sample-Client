//
//  FirebaseSampleAdapter.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 17.01.25.
//

import FirebaseFirestore
import Foundation
import OSLog

class FirebaseSampleAdapter: SampleAdapterProtocol {

    private let db = Firestore.firestore()
    private let collectionName = "samples"

    func fetchSamples() async -> [Sample] {
        do {
            let samples = try await db.collection(collectionName).getDocuments().documents.compactMap {
                document in
                try? document.data(as: Sample.self)
            }
            return samples
        } catch {
            Logger.firestore.error("Error fetching Samples: \(error.localizedDescription)")
            return []
        }
    }

    private func fillSamples() {
        do {
            for sample in Sample.mockList {
                try db.collection(collectionName)
                    .addDocument(from: sample)
            }
        } catch {
            Logger.firestore.error("Error adding Sample: \(error.localizedDescription)")
        }
    }
}
