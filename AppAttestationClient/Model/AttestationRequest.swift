//
//  AttestationRequest.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 17.02.25.
//
import Foundation

struct AttestationRequest: Codable {
    let attestation: Data
    let keyID: Data
    let challengeID: UUID
}
