//
//  Mockable.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//
import Foundation

// MARK: - Mockable

public protocol Mockable {
    associatedtype MockType

    static var mock: MockType { get }
    static var mockList: [MockType] { get }
}

public extension Mockable {
    static var mock: MockType {
        mockList[0]
    }

    static var mockList: [MockType] { [] }
}
