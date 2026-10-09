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

    // Pagination state
    private var currentPage = 1
    private var canLoadMore = true
    private let pageSize = 20

    // Dependency injected from outside
    private let repository: CoinRepository

    init(repository: CoinRepository) {
        self.repository = repository
    }

    // Coins to show: all coins, or only the ones matching the search text
    var filteredCoins: [Coin] {
        guard !searchText.isEmpty else { return coins }
        return coins.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.symbol.localizedCaseInsensitiveContains(searchText)
        }
    }

    // Load the first page
    func loadCoins() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        currentPage = 1

        do {
            let result = try await repository.fetchCoins(page: 1, perPage: pageSize)
            coins = result
            // Only allow more pages if this page was full
            canLoadMore = result.count == pageSize
        } catch {
            print("Load error: \(error)")
            errorMessage = "Failed to load coins. Please try again."
        }

        isLoading = false
    }

    // Load the next page when the user reaches near the end of the list
    func loadMoreIfNeeded(currentCoin coin: Coin) async {
        // Do nothing while searching (we only filter loaded coins)
        guard searchText.isEmpty else { return }
        guard !isLoading, canLoadMore else { return }

        // Continue only if this coin is within the last 5 items of the list
        let thresholdIndex = coins.index(coins.endIndex, offsetBy: -5, limitedBy: coins.startIndex) ?? coins.startIndex
        guard let coinIndex = coins.firstIndex(where: { $0.id == coin.id }),
              coinIndex >= thresholdIndex else { return }

        isLoading = true
        let nextPage = currentPage + 1

        do {
            let result = try await repository.fetchCoins(page: nextPage, perPage: pageSize)
            // Add new coins to the end of the existing list
            coins.append(contentsOf: result)
            currentPage = nextPage
            canLoadMore = result.count == pageSize
        } catch {
            print("Load more error: \(error)")
            // Keep the existing list so the user can retry by scrolling again
        }

        isLoading = false
    }
}
