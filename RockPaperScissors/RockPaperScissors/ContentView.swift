//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Chris Boette on 9/21/23.
//

import SwiftUI

struct ContentView: View {
    @State var roundCount = 0
    @State var score = 0
    @State var playerChoice = ""
    @State var isGameOver = false
    @State var showStatus = false
    @State var status = ""

    let ROUNDS = 10
    let choices = ["🪨", "✂️", "📄"]
    let goals = ["🥇", "💀"]
    
    @State var machineInd = Int.random(in: 0..<3)
    @State var goalsInd = Int.random(in: 0..<2)

    var body: some View {
        Spacer()
        
        VStack {
            VStack {
                Text("I expect you to \(goals[goalsInd]).")
                Text("How do you respond?")
            }
            .font(.title)
        }
        .padding()
        .alert("", isPresented: $isGameOver) {
            Button("Try again?", action: reset)
        } message: {
            Text("That last round? You \(status).\nTraining complete.\nYour final score is \(score).")
        }

        Picker("Choose your weapon", selection: $playerChoice) {
            ForEach(choices, id: \.self) {
                Button($0) {
                    showStatus.toggle()
                    machineInd = Int.random(in: 0..<3)
                }
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .disabled(!status.isEmpty)
                
        Button("Fire!", action: calcAndScore)
            .buttonStyle(.borderedProminent)
            .disabled(playerChoice.isEmpty || !status.isEmpty)

        Spacer()

        if showStatus {
            Text("The machine chose \(choices[machineInd]).\nYou chose \(playerChoice). You \(status).")
            Button("Again!", action: resetRound)
                .padding()
        }
        
        Spacer()
        
        Text("Score: \(score)")
        Text("Roound: \(roundCount)/\(ROUNDS)")
    }
    
    func resetRound() {
        showStatus.toggle()

        machineInd = Int.random(in: 0..<3)
        goalsInd = Int.random(in: 0..<2)
        playerChoice = ""
        status = ""
    }
    
    func calcAndScore() {
        let playerInd = choices.firstIndex(of: playerChoice) ?? -1
        let playerWon = didWin(playerInd)

        if (playerWon && goalsInd == 0) || (!playerWon && goalsInd == 1) {
            status = "won"
            score += 1
        } else {
            status = "lost"
            score -= 1
        }
        
        
        showStatus.toggle()

        roundCount += 1

        if roundCount == ROUNDS {
            isGameOver.toggle()
        }

    }

    func didWin(_ playerInd: Int) -> Bool {
        if playerInd == 0 && machineInd == 1 {
            return true
        }

        if playerInd == 1 && machineInd == 2 {
            return true
        }

        if playerInd == 2 && machineInd == 0 {
            return true
        }

        return false
    }

    func reset() {
        roundCount = 0
        score = 0
        playerChoice = ""
        isGameOver.toggle()
        showStatus.toggle()
        status = ""
    }
}

#Preview("Nombre iOS") {
    ContentView()
}
