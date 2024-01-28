//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Chris Boette on 9/15/23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var showingRoundEnd = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCount = 0
    @State private var tapped = -1
    
    @State private var degrees = 0.0
    @State private var opacity = 1.0

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            tapped = number
                            withAnimation {
                                flagTapped(number)
                                degrees += 360
                            }
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .rotation3DEffect(
                            Angle(degrees: number == tapped ? degrees : 0),
                            axis: (x: 0.0, y: 1.0, z: 0.5)
                        )
                        .opacity(number != tapped && tapped > -1 ? opacity : 1.0)
                        .animation(.easeOut, value: tapped)
                        .scaleEffect(number != tapped && tapped > -1 ? 0.5 : 1.0)
                        .animation(.spring, value: tapped)
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is now \(score).")
        }
        .alert("", isPresented: $showingRoundEnd) {
            Button("Start over?", action: reset)
        } message: {
            Text("All done. Your ending score is \(score).")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong. The answer is flag #\(correctAnswer+1)."
            score -= 1
        }
        opacity = 0.25
        questionCount += 1
        if questionCount == 8 {
            showingRoundEnd = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        tapped = -1
        opacity = 1.0
    }
    
    func reset() {
        scoreTitle = ""
        score = 0
        questionCount = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
