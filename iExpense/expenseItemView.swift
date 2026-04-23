//
//  expenseItemView.swift
//  iExpense
//
//  Created by Delirious on 4/23/26.
//

import SwiftUI

struct ExpenseItemView: View {
    
    let item: ExpenseItem
    
    var icon: String {
        item.type == "Personal" ? "person.fill" : "briefcase.fill"
    }
    var iconColor: Color {
        item.type == "Personal" ? .blue : .orange
    }
    var amountColor: Color {
        item.amount < 10 ? .green : item.amount < 100 ? .orange : .red
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            RoundedRectangle(cornerRadius: 8)
                .fill(iconColor)
                .frame(width: 36, height: 36)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .medium))
                }
            // Name + type badge
            VStack (alignment: .leading, spacing: 4){
                Text(item.name)
                    .font(.body)
                    .foregroundStyle(.primary)
                Text(item.type)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                    .background(iconColor.opacity(0.15))
                    .foregroundStyle(iconColor)
                    .clipShape(Capsule())
            }
            Spacer() // pushes amount to the right
            
            Text(item.amount, format: .currency(code: "USD"))
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(amountColor)
        }
        .padding(.vertical, 4)
    }
}
#Preview {
    VStack {
        ExpenseItemView(item: ExpenseItem(name: "Drink", type: "Personal", amount: 4.50))
        ExpenseItemView(item: ExpenseItem(name: "Macbook", type: "Business", amount: 1299.00))
        ExpenseItemView(item: ExpenseItem(name: "Lunch", type: "Personal", amount: 85.00))
    }
    .padding()
}

