import Foundation
import Observation

@Observable
@MainActor
final class CoinListViewModel {

    // State that the View will display
    var coins: [Coin] = []
    var isLoading = false
    var errorMessage: String?

    // The text typed in the search bar
    var searchText = ""

    // Coins to show: all coins, or only the ones matching the search text
    var filteredCoins: [Coin] {
        guard !searchText.isEmpty else { return coins }
        return coins.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.symbol.localizedCaseInsensitiveContains(searchText)
        }
    }

    private let service = CoinAPIService()

    // Load the first page of coins
    func loadCoins() async {
        // Prevent duplicate calls while already loading
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            coins = try await service.fetchCoins(page: 1)
        } catch {
            // Print the real error to the console for debugging
            print("Load error: \(error)")
            errorMessage = "Failed to load coins. Please try again."
        }

        isLoading = false
    }
}
