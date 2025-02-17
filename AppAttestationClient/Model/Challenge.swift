//
//  Challenge.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 17.02.25.
//
import Foundation

struct Challenge: Codable {
    let id: UUID
    let data: Data
}
