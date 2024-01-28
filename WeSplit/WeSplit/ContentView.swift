//
//  ContentView.swift
//  WeSplit
//
//  Created by Chris Boette on 8/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool

    let tipPercentages = 0..<101
    
    var grandTotal: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection

        return checkAmount + tipValue
    }
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        
        return grandTotal / peopleCount
    }
    
    var currencyFormatter: FloatingPointFormatStyle<Double>.Currency {
        return .currency(code: Locale.current.currency?.identifier ?? "USD")
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: currencyFormatter)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("No. of people", selection: $numberOfPeople) {
                        ForEach(2 ..< 100) {
                            Text("\($0) ppl")
                        }
                    }
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("How much tip do you want to leave?")
                }
                
                Section {
                    Text(grandTotal, format: currencyFormatter)
                } header: {
                    Text("All in, with tip")
                }
                
                Section {
                    Text(totalPerPerson, format: currencyFormatter)
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
