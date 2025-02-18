//
//  SampleAdapterProtocol.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import Foundation

protocol SampleAdapterProtocol {

    func fetchSamples() async -> [Sample]
    func fetchSamples(with assertion: AssertionRequest) async -> [Sample]
}
