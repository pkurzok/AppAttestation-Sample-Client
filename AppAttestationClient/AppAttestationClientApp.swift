//
//  AppAttestationClientApp.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import Firebase
import SwiftUI

@main struct AppAttestationClientApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
