//
//  ContentView.swift
//  SinceEpoch Watch App
//
//  Created by Chris Boette on 10/6/23.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTime = "0"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("\(currentTime)")
            .font(.largeTitle)
            .foregroundColor(.green)
            .monospaced()
            .onReceive(timer) { input in
                currentTime = String(Int(input
                    .timeIntervalSince1970))
                    .split(separator: "")
                    .chunkInto(count: 3)
                    .joined(separator: "\n")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .layoutPriority(1)
            .edgesIgnoringSafeArea(.all)
    }
}

extension Array where Element == String.SubSequence {
    func chunkInto(count: Int) -> [String] {
        var result: [String] = []
        var tempString = ""

        for str in self {
            tempString += str
            if tempString.count == count {
                result.append(tempString)
                tempString = ""
            }
        }

        if !tempString.isEmpty {
            result.append(tempString)
        }

        return result
    }
}

#Preview {
    ContentView()
}
