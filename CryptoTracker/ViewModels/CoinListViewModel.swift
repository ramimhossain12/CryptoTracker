import Foundation
import Observation

@Observable
@MainActor
final class CoinListViewModel {

    var coins: [Coin] = []
    var isLoading = false
    var errorMessage: String?
    var searchText = ""

    // Pagination state
    private var currentPage = 1
    private var canLoadMore = true
    private let pageSize = 20

    var filteredCoins: [Coin] {
        guard !searchText.isEmpty else { return coins }
        return coins.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.symbol.localizedCaseInsensitiveContains(searchText)
        }
    }

    private let service = CoinAPIService()

    // Load the first page
    func loadCoins() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        currentPage = 1

        do {
            let result = try await service.fetchCoins(page: 1, perPage: pageSize)
            coins = result
            // TODO 1: set canLoadMore to true only if result.count == pageSize
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

        // TODO 2: only continue if `coin` is the last item in `coins`
        //         (compare coin.id with coins.last?.id, otherwise return)

        isLoading = true
        let nextPage = currentPage + 1

        do {
            let result = try await service.fetchCoins(page: nextPage, perPage: pageSize)
            // TODO 3: append result to coins (use coins.append(contentsOf: result))
            currentPage = nextPage
            canLoadMore = result.count == pageSize
        } catch {
            print("Load more error: \(error)")
            // Keep the existing list, just stop here so the user can retry by scrolling
        }

        isLoading = false
    }
}
