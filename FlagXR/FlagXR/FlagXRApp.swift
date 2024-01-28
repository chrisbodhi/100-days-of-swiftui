//
//  FlagXRApp.swift
//  FlagXR
//
//  Created by Chris Boette on 9/18/23.
//

import SwiftUI

@main
struct FlagXRApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
