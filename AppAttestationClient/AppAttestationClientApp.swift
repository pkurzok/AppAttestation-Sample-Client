//
//  AppAttestationClientApp.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import Firebase
import FirebaseAppCheck
import SwiftUI

@main struct AppAttestationClientApp: App {

    init() {
#if DEBUG
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
