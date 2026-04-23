import SwiftUI

struct ExpenseItem: Identifiable, Encodable, Decodable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    
    var personalExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal" }
    }
    var businessExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Business"}
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(personalExpenses) { item in
                        ExpenseItemView(item: item)
                        
                    }
                    .onDelete { offsets in removeItems(ofType: "Personal", at: offsets) }
                }
                
                Section("Business") {
                        ForEach(businessExpenses) { item in
                        ExpenseItemView(item: item)
                        }
                    .onDelete { offsets in removeItems(ofType: "Business", at: offsets) }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                // show an AddView here
                AddView(expenses: expenses)
            }
        }
    }
    func removeItems(ofType type: String, at offsets: IndexSet) {
        let filtered = expenses.items.filter { $0.type == type }
        let idsToDelete = offsets.map { filtered[$0].id }
        expenses.items.removeAll { idsToDelete.contains($0.id) }
    }
}

#Preview {
    ContentView()
}
