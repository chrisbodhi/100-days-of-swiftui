//
//  ContentView.swift
//  Moonshot
//
//  Created by Chris Boette on 10/20/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var missionSelection: Mission? = nil
    @State private var astronautSelection: Astronaut? = nil

    var body: some View {
        NavigationSplitView {
            List(missions, selection: $missionSelection) { mission in
                NavigationLink(value: mission) {
                    VStack {
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()

                        VStack {
                            Text(mission.displayName)
                                .font(.title)
                            Text(mission.formattedLaunchDate)
                                .font(.title3)
                        }
                        .padding(.all, 30)
                        .background(.lightBackground)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.darkBackground)
                        )
                    }
                    .padding()
                    .border(.lightBackground)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        } content: {
            if let mission = missionSelection {
                MissionView(mission: mission, astronauts: astronauts, astronautSelection: $astronautSelection)
            } else {
                Text("Pick a mission.")
            }
        } detail: {
            if let astronaut = astronautSelection {
                AstronautView(astronaut: astronaut)
            } else {
                Text("Waiting on an astronaut.")
            }
        }
        .onChange(of: missionSelection) {
            astronautSelection = nil
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
