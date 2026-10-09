import Foundation

// Contract: anything that can provide coins must implement this
protocol CoinRepository {
    func fetchCoins(page: Int, perPage: Int) async throws -> [Coin]
}

// Real implementation that uses the network service
struct DefaultCoinRepository: CoinRepository {
    private let service: CoinAPIService

    // The service is passed in, with a default value for convenience
    init(service: CoinAPIService = CoinAPIService()) {
        self.service = service
    }

    func fetchCoins(page: Int, perPage: Int) async throws -> [Coin] {
        try await service.fetchCoins(page: page, perPage: perPage)
    }
}
