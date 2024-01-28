//
//  Mission.swift
//  Moonshot
//
//  Created by Chris Boette on 10/21/23.
//

import Foundation

struct Mission: Codable, Identifiable, Hashable {
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Mission, rhs: Mission) -> Bool {
        return lhs.id == rhs.id
    }
}

