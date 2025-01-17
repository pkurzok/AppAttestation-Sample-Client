//
//  App+Logger.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import OSLog

extension Logger {
    private static var subsystem = "App Attestation Client"

    static let general = Logger(subsystem: subsystem, category: "General")
    static let sampleApi = Logger(subsystem: subsystem, category: "Sample API")
    static let firestore = Logger(subsystem: subsystem, category: "Firestore")
}
