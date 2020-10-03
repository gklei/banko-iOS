//
//  ExpensesView.swift
//  banko
//
//  Created by Gregory Klein on 10/2/20.
//

import SwiftUI

struct ExpensesView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
         .navigationTitle("Expenses")
         .navigationBarItems(
            trailing: Button("Add Expense") {
               print("Add expense button pressed")
            }
         )
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
