//
//  MissionView.swift
//  Moonshot
//
//  Created by Chris Boette on 10/22/23.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember: Hashable, Identifiable {
        let id = UUID()
        let role: String
        let astronaut: Astronaut

        static func == (lhs: MissionView.CrewMember, rhs: MissionView.CrewMember) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(role)
        }
    }

    let mission: Mission
    let crew: [CrewMember]
    @Binding var astronautSelection: Astronaut?
    
    init(mission: Mission, astronauts: [String: Astronaut], astronautSelection: Binding<Astronaut?>) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
        self._astronautSelection = astronautSelection
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.3)
                        .padding(.top)
                    
                    Text(mission.formattedLaunchDate)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    
                    FullWidthDivider(height: 2)

                    VStack(alignment: .leading) {
                        Text("Mission highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        Text(mission.description)
                    }
                    .padding(.horizontal)
                    
                    FullWidthDivider(height: 2)
                    
                    Text("Crew")
                        .font(.title)
                        .padding(.bottom, 5)
                                        
                    CrewList(crew: crew, astronautSelection: $astronautSelection)
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let selection: Astronaut = astronauts[missions[1].crew[1].name]!
    let selectionBinding = Binding<Astronaut?>.constant(selection)
    
    return MissionView(mission: missions[1], astronauts: astronauts, astronautSelection: selectionBinding)
        .preferredColorScheme(.dark)
}

// Alternative to Divider()
struct FullWidthDivider: View {
    let height: CGFloat?

    var body: some View {
        Rectangle()
            .frame(height: height ?? 1.0)
            .foregroundColor(.lightBackground)
            .padding(.vertical)
    }
}

struct CrewList: View {
    let crew: [MissionView.CrewMember]
    @Binding var astronautSelection: Astronaut?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew) { crewMember in
                    HStack {
                        Image(crewMember.astronaut.id)
                            .resizable()
                            .frame(width: 104, height: 72)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().strokeBorder(.white, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(crewMember.astronaut.name)
                                .foregroundColor(.white)
                                .font(.headline)
                            Text(crewMember.role)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        self.astronautSelection = crewMember.astronaut
                    }
                }
            }
        }
    }
}
