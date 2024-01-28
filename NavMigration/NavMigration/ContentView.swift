//
//  ContentView.swift
//  NavMigration
//
//  Created by Chris Boette on 10/22/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    let colors: [Color] = [.purple, .pink, .orange]
    @State private var selection: Color? = nil // Nothing selected by default.

    var body: some View {
        NavigationSplitView {
            List(colors, id: \.self, selection: $selection) { color in
                NavigationLink(color.description, value: color)
            }
        } detail: {
            if let color = selection {
                ColorDetail(color: color)
            } else {
                Text("Pick a color")
            }
                
        }
    }
}

struct ColorDetail: View {
    var color: Color
    
    var body: some View {
        color.navigationTitle(color.description)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
