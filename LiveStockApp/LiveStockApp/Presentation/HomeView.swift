//
//  ContentView.swift
//  LiveStockApp
//
//  Created by Taher on 25/4/23.
//

import SwiftUI
import WidgetKit

struct HomeView: View {

    @Environment(\.scenePhase) var scenePhase
    @ObservedObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            List {
                HStack {
                    TextField("Symbol", text: $viewModel.symbol)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add", action: viewModel.addStock)
                        .disabled(!viewModel.isValidSymbol)
                }
                if !viewModel.stockDataList.isEmpty {
                    ForEach(viewModel.stockDataList) { stock in
                        HStack {
                            Text(stock.metaData.symbol)
                            Spacer()
                            LineChart(values: stock.closeValues)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.green.opacity(0.7), .green.opacity(0.2),.green.opacity(0.0)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 150.0, height: 50.0)

                            VStack(alignment: .trailing) {
                                Text(stock.latestClose)
                            }
                            .frame(width: 100.0)
                        }
                    }
                    .onDelete(perform: viewModel.deleteStock(at:))
                } else {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .navigationTitle("My Stocks")
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                WidgetCenter.shared.reloadTimelines(ofKind: "StocksWidget")
            }
        }
        .onOpenURL { url in
            guard url.scheme == "livestockapp",
                  url.host == "symbol" else {
                return
            }
            let stockSymbol = url.pathComponents[1]
            viewModel.symbol = stockSymbol
            viewModel.addStock()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
