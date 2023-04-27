//
//  ContentView.swift
//  LiveStockApp
//
//  Created by Taher on 25/4/23.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            List {
                if !viewModel.stockDataList.isEmpty {
                    ForEach(viewModel.stockDataList) { stock in
                        HStack {
                            Text(stock.metaData.symbol)
                            Spacer()
                            RoundedRectangle(cornerRadius: 10.0)
                                .frame(width: 150, height: 50.0)
                            VStack(alignment: .trailing) {
                                Text(stock.latestClose)
                                Text("change")
                            }
                        }
                    }
                } else {
                    Text("No Data found")
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
