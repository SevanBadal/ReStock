//
//  SearchBar.swift
//  ReStock
//
//  Created by Sevan Golnazarian on 3/27/20.
//  Copyright © 2020 Sevan Golnazarian. All rights reserved.
//

import SwiftUI

struct CustomInputField: View {
    
    let title: String
    let exampleStocks: [String] = ["zm", "s", "work","twtr","tcehy"]
    var stockSymbol: Binding<String>
    
    init(for stockSymbol: Binding<String>, title: String) {
        self.title = title
        self.stockSymbol = stockSymbol
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .bold()
            TextField(exampleStocks.randomElement()!, text: stockSymbol)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}

#if DEBUG
struct PreviewHelper: View {
    @State var bindedItem: String = ""
    var body: some View {
        CustomInputField(for: $bindedItem, title: "Stock One")
    }
}

struct CustomInputField_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHelper()
    }
}
#endif
