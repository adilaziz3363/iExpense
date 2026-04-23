import SwiftUI

struct ExpenseItem: Identifiable, Encodable, Decodable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currency: String
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

struct SummaryCard: View {
    let title: String
    let total: Double
    let currency: String
    let color: Color
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 36, height: 36)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .medium))
                }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(total, format: .currency(code: currency))
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct ContentView: View {

    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var itemToEdit: ExpenseItem? = nil

    var personalExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal" }
    }
    var businessExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Business" }
    }
    var personalTotal: Double {
        personalExpenses.reduce(0) { $0 + $1.amount }
    }
    var businessTotal: Double {
        businessExpenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            Group {
                if expenses.items.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Text("No expenses yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Tap the button below to add your first one")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button {
                            showingAddExpense = true
                        } label: {
                            Label("Add Expense", systemImage: "plus")
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding()
                } else {
                    List {
                        Section {
                            HStack(spacing: 12) {
                                SummaryCard(
                                    title: "Personal",
                                    total: personalTotal,
                                    currency: personalExpenses.first?.currency ?? "USD",
                                    color: .blue,
                                    icon: "person.fill"
                                )
                                SummaryCard(
                                    title: "Business",
                                    total: businessTotal,
                                    currency: businessExpenses.first?.currency ?? "USD",
                                    color: .orange,
                                    icon: "briefcase.fill"
                                )
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }

                        if !personalExpenses.isEmpty {
                            Section("Personal") {
                                ForEach(personalExpenses) { item in
                                    ExpenseItemView(item: item)
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                itemToEdit = item
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                removeItem(withID: item.id)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }

                        if !businessExpenses.isEmpty {
                            Section("Business") {
                                ForEach(businessExpenses) { item in
                                    ExpenseItemView(item: item)
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                itemToEdit = item
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            .tint(.blue)
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                removeItem(withID: item.id)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                    .sheet(item: $itemToEdit) { item in
                        EditView(expenses: expenses, item: item)
                    }
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
                AddView(expenses: expenses)
            }
        }
    }

    func removeItem(withID id: UUID) {
        expenses.items.removeAll { $0.id == id }
    }
}

#Preview {
    ContentView()
}
