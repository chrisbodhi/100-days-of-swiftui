//
//  ContentView.swift
//  iExpense
//
//  Created by Chris Boette on 10/16/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddExpense = false
    @StateObject var expenses = Expenses()

    var body: some View {
        NavigationView {
            List {
                Text("Personal")
                    .font(.title3)

                ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text(item.amount, format: currencyFormatter)
                            .modifier(DollaModifiah(amount: item.amount))
                    }
                }
                .onDelete { removeItems(at: $0, type: "Personal") }
                
                Text("Business")
                    .font(.title3)
                
                ForEach(expenses.items.filter { $0.type == "Business" }) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text(item.amount, format: currencyFormatter)
                            .modifier(DollaModifiah(amount: item.amount))
                    }
                }
                .onDelete { removeItems(at: $0, type: "Business") }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet, type: String) {
        let index = offsets.first!
        let filtered = expenses.items.filter { $0.type == type }
        let toDelete = filtered[index]

        expenses.items.removeAll { $0.id == toDelete.id }
    }
}

struct DollaModifiah: ViewModifier {
    var amount: Double
    
    func body(content: Content) -> some View {
        if amount < 10 {
            return content.foregroundStyle(.green)
        }
        if amount > 100 {
            return content.foregroundStyle(.purple)
        }
        return content.foregroundStyle(.cyan)
    }
}

#Preview {
    ContentView()
}
