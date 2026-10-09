import Foundation

// Fake repository for previews and tests (no internet needed)
struct MockCoinRepository: CoinRepository {

    // Control the behavior from outside
    var coins: [Coin] = []
    var shouldFail = false

    func fetchCoins(page: Int, perPage: Int) async throws -> [Coin] {
        if shouldFail {
            throw NetworkError.unknown
        }

        // Simulate the pagination: return the right slice of coins
        let start = (page - 1) * perPage
        guard start < coins.count else { return [] }
        let end = min(start + perPage, coins.count)
        return Array(coins[start..<end])
    }
}

extension MockCoinRepository {
    // Generate fake coins like "Coin 1", "Coin 2", ...
    static func withSampleCoins(count: Int = 50) -> MockCoinRepository {
        let fakeCoins = (1...count).map { number in
            Coin(
                id: "coin-\(number)",
                symbol: "c\(number)",
                name: "Coin \(number)",
                image: "",
                currentPrice: Double(number) * 100,
                marketCapRank: number,
                priceChangePercentage24h: number % 2 == 0 ? 1.5 : -2.3
            )
        }
        return MockCoinRepository(coins: fakeCoins)
    }
}
