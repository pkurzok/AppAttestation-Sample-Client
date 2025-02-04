//
//  DeviceCheckAdapter.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 24.01.25.
//

import DeviceCheck
import Foundation
import OSLog

protocol DeviceCheckProtocol {
    var deviceToken: Data? { get async }
}

struct DeviceCheckAdapter: DeviceCheckProtocol {

    var deviceToken: Data? {
        get async {
            guard DCDevice.current.isSupported else {
                Logger.deviceCheck.error("Device Check is not supported on this device")
                return nil
            }

            do {
                let token = try await DCDevice.current.generateToken()
                Logger.deviceCheck.debug("Generated Token: \(token.base64EncodedString())")
                return token
            } catch {
                Logger.deviceCheck.error("Failed to generate device token: \(error)")
                return nil
            }
        }
    }
}
