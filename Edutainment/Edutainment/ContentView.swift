//
//  ContentView.swift
//  Edutainment
//
//  Created by Chris Boette on 10/4/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showStart = true
    @State private var howMany = 5
    @State private var tables = 2
    @State private var roundsCompleted = 0
    @State private var score = 0
    
    var body: some View {
        if showStart {
            StartView(showStart: $showStart, howMany: $howMany, tables: $tables, begin: begin)
        } else {
            MathView(howMany: $howMany, roundsCompleted: $roundsCompleted, tables: $tables, score: $score, end: end)
        }
    }
    
    func begin() {
        showStart = false
    }
    
    func end() {
        showStart = true
        howMany = 5
        tables = 2
        roundsCompleted = 0
        score = 0
    }
}

struct StartView: View {
    @Binding var showStart: Bool
    @Binding var howMany: Int
    @Binding var tables: Int
    
    var begin: () -> ()

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "multiply.square")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Go forth, and multiply!")
            Spacer()
            Stepper("Up to...\(tables)", value: $tables)
            Stepper("Let's go \(howMany) rounds.", value: $howMany, in: 5...20, step: 5)
            Button(action: begin) {
                Label(showStart ? "Start" : "End", systemImage: "brain")
            }
            Spacer()
        }
        .padding()
    }
}

struct MathView: View {
    enum FocusedField {
        case input
    }
    @Binding var howMany: Int
    @Binding var roundsCompleted: Int
    @Binding var tables: Int
    @Binding var score: Int

    var end: () -> ()

    @State private var isDone = false
    @State private var multiplicand = 1
    @State private var multiplier = 1
    @State private var status = ""
    @State private var productGuess = ""
    @State private var hasAnswered = false
    @State private var timeRemaining = 10
    
    @FocusState private var focusedField: FocusedField?
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Text("doing it")
            if roundsCompleted < howMany {
                Text("more math")
                HStack {
                    Text("\(multiplicand) x \(multiplier) =")
                    TextField("?", text: $productGuess)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .input)
                        .frame(width: 45)
                        .padding(10)
                        .border(.secondary)
                        .onSubmit {
                            let product = multiplicand * multiplier
                            if Int(productGuess) == product {
                                status = "Good!"
                                score += (1 * timeRemaining)
                            } else {
                                status = "Should have been \(product)"
                            }
                            hasAnswered = true
                        }
                }
                .font(.largeTitle)
                Text("\(timeRemaining)")
                    .font(.largeTitle)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
            }
            Spacer()
            Button("back", action: end)
        }
        .onAppear {
            multiplicand = getRandom()
            multiplier = getRandom()
            
            focusedField = .input
        }
        .alert("\(status)", isPresented: $hasAnswered) {
            Button("Next") {
                inc()
            }
        }
        .alert("All done, player.", isPresented: $isDone) {
            Button("Start over", action: end)
        } message: {
            Text("Your final score is \(score).")
        }
    }
    
    func getRandom() -> Int {
        let tablesPlus = tables + 1
        let range = 1..<tablesPlus // This could be calc'd once

        return Int.random(in: range)
    }
    
    func inc() {
        roundsCompleted += 1
        if roundsCompleted == howMany {
            isDone = true
        }
        multiplicand = getRandom()
        multiplier = getRandom()
        productGuess = ""
        status = ""
        focusedField = .input
        timeRemaining = 10
    }
}

#Preview {
    ContentView()
}
