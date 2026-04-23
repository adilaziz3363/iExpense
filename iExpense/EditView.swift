//
//  EditView.swift
//  iExpense
//
//  Created by Delirious on 4/23/26.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var type: String
    @State private var amount: String
    @State private var currency: String
    
    var expenses: Expenses
    var item: ExpenseItem
    
    let types = ["Personal", "Business"]
    let currencies = ["USD", "PKR", "EUR", "GBP", "JPY", "CAD", "AUD"]
    
    init(expenses: Expenses, item: ExpenseItem) {
        self.expenses = expenses
        self.item = item
        _name = State(initialValue: item.name)
        _type = State(initialValue: item.type)
        _amount = State(initialValue: String(item.amount))
        _currency = State(initialValue: item.currency)
    }
        
        var body: some View {
            NavigationStack {
                Form {
                    TextField("Name", text: $name)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { Text($0) }
                    }
                    
                    Picker("Currency", selection: $currency) {
                        ForEach(currencies, id: \.self) { Text($0) }
                    }
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                
            }
                .navigationTitle("Edit Expense")
                .toolbar {
                    Button("Save") {
                        let amountValue = Double(amount) ?? 0.0
                        if let index = expenses.items.firstIndex(where: { $0.id == item.id }) {
                            expenses.items[index] = ExpenseItem(
                                id: item.id, name: name, type: type, amount: amountValue, currency: currency
                            )
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty || amount.isEmpty || Double(amount) == nil)
                }
            }
        }
        
}



#Preview {
    EditView(expenses: Expenses(), item: ExpenseItem(name: "Coffee", type: "Personal", amount: 4.50, currency: "USD"))
}

