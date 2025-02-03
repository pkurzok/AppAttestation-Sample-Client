//
//  InfoPlistAdapter.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 24.01.25.
//

import Foundation
import OSLog

// MARK: - InfoPlistAdapter

enum InfoPlistAdapter {
    static var baseUrl: String {
        InfoDictionary.string(forKey: .baseUrl)!
    }

    static var bundleId: String {
        InfoDictionary.string(forKey: .bundleId)!
    }
}

// MARK: - InfoDictionary

enum InfoDictionary {
    enum Key: String {
        case bundleId = "CFBundleIdentifier"
        case baseUrl = "BaseUrl"
    }

    static func string(forKey key: Key) -> String? {
        guard let string = (Bundle.main.infoDictionary?[key.rawValue] as? String) else {
            Logger.general.error("InfoDictionary value for \(key.rawValue, privacy: .public) is missing or failed to convert to String")
            return nil
        }
        return string.replacingOccurrences(of: "\\", with: "")
    }
}
