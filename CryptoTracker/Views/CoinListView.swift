import SwiftUI

struct CoinListView: View {
    @State private var viewModel = CoinListViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredCoins) { coin in
                    CoinRowView(coin: coin)
                        .task {
                            // Ask the ViewModel to load more if this is the last row
                            await viewModel.loadMoreIfNeeded(currentCoin: coin)
                        }
                }

                // Small spinner at the bottom while loading the next page
                if viewModel.isLoading && !viewModel.coins.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Crypto")
            .searchable(text: $viewModel.searchText, prompt: "Search coins")
            .overlay {
                // Show a spinner while loading the first time
                if viewModel.isLoading && viewModel.coins.isEmpty {
                    ProgressView()
                }
                // Show an error message if loading failed
                if let message = viewModel.errorMessage {
                    Text(message)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                // Show "No Results" when search finds nothing
                if !viewModel.searchText.isEmpty && viewModel.filteredCoins.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
                }
            }
            .task {
                // Load data when the screen appears
                await viewModel.loadCoins()
            }
        }
    }
}

#Preview {
    CoinListView()
}
