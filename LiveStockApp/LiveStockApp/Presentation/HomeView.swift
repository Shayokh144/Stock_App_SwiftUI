//
//  ContentView.swift
//  LiveStockApp
//
//  Created by Taher on 25/4/23.
//

import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationView {
            List {
                ForEach(0...10, id: \.self) { number in

                    HStack {
                        Text("symbol")
                        Spacer()
                        RoundedRectangle(cornerRadius: 10.0)
                            .frame(width: 150, height: 50.0)
                        VStack(alignment: .trailing) {
                            Text("value")
                            Text("change")
                        }
                    }
                }
            }
            .navigationTitle("My Stocks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    EditButton()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
