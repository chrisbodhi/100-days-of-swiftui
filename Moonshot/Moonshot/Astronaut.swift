//
//  Astronaut.swift
//  Moonshot
//
//  Created by Chris Boette on 10/20/23.
//

import Foundation

struct Astronaut: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Astronaut, rhs: Astronaut) -> Bool {
        return lhs.id == rhs.id
    }
}
