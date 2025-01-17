//
//  AppAttestationClientApp.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import Firebase
import SwiftUI

#if DEBUG
import Atlantis
import FirebaseAppCheck
#endif

// MARK: - AppAttestationClientApp

@main struct AppAttestationClientApp: App {
    init() {
#if DEBUG
        Atlantis.start()

        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
#endif

        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
