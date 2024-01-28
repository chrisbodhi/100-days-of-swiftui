//
//  ContentView.swift
//  WordScramble
//
//  Created by Chris Boette on 9/27/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    let minLength = 3

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Score:")
                        .bold()
                    Text("\(score)")
                }
                .listRowBackground(Color.clear)

                Section {
                    TextField("Entre tu palabra", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .toolbar(content: {
                Button("Restart", action: startGame)
            })
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("Aight", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        guard isOriginal(word: answer) else {
            wordError(title: "Already used", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Not possible", message: "You can't spell that word from \(rootWord).")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Not recognized", message: "That's not a word.")
            return
        }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Not long enough", message: "Needs to be at least \(minLength) chars long.")
            return
        }
        
        guard isNotStartWord(word: answer) else {
            wordError(title: "Nice try.", message: "Try harder.")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        score += answer.count
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: .newlines)
                
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = []
                score = 0
                
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isLongEnough(word: String) -> Bool {
        word.count >= minLength
    }
    
    func isNotStartWord(word: String) -> Bool {
        word != rootWord
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
