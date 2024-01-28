//
//  ContentView.swift
//  BetterRest
//
//  Created by Chris Boette on 9/22/23.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var coffeeAmount = 1
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var suggestion = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date.now
    }

    var body: some View {
        let wakeUpBinding = Binding(
            get: { self.wakeUp },
            set: {
                self.wakeUp = $0
                calculateBedtime()
            }
        )
        
        let sleepAmountBinding = Binding(
            get: { self.sleepAmount },
            set: {
                self.sleepAmount = $0
                self.calculateBedtime()
            }
        )

        let coffeeBinding = Binding(
            get: { self.coffeeAmount },
            set: {
                self.coffeeAmount = $0
                self.calculateBedtime()
            }
        )

        NavigationView {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: wakeUpBinding, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: sleepAmountBinding, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Daily coffee intake")
                        .font(.headline)
                
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: coffeeBinding, in: 0...100)
                    
                    Picker("Cups", selection: $coffeeAmount) {
                        ForEach(1...41, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                Section("Your ideal bedtime is...") {
                    Text(suggestion.isEmpty ? "" : "\(suggestion) is coming up.")
                        .font(.largeTitle)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            suggestion = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            suggestion = "Sorry, there was a problem calculating your bedtime."
        }
    }
}

#Preview("Wassup.") {
    ContentView()
}
