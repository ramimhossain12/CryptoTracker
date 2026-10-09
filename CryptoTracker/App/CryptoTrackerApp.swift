import SwiftUI

@main
struct CryptoTrackerApp: App {
    // Composition root: the only place where we create the real objects
    private let repository = DefaultCoinRepository()

    var body: some Scene {
        WindowGroup {
            CoinListView(viewModel: CoinListViewModel(repository: repository))
        }
    }
}
