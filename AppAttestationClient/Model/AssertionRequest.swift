//
//  AssertionRequest.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 18.02.25.
//
import Foundation

struct AssertionRequest: Codable {
    let assertion: Data
    let keyID: Data
    let challengeID: UUID
    let clientData: Data
}
