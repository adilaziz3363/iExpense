//
//  AddView.swift
//  iExpense
//
//  Created by Delirious on 4/22/26.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var currency = "PKR"
    @State private var amount : String = ""
    
    var expenses: Expenses

    let types = ["Personal", "Business"]
    let currencies = ["USD", "PKR", "EUR", "GBP", "JPY", "CAD", "AUD"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                Picker("Currency", selection: $currency) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let amountValue = Double(amount) ?? 0
                    let item = ExpenseItem(name: name, type: type, amount: amountValue, currency: currency)
                    expenses.items.append(item)
                    dismiss()
                }
                .disabled(name.isEmpty || amount.isEmpty || Double(amount) == nil)
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
