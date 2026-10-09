import Foundation

struct CoinAPIService {

    // Fetch one page of coins from CoinGecko
    func fetchCoins(page: Int, perPage: Int = 20) async throws -> [Coin] {

        // Build the URL with query parameters
        var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/markets")
        components?.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "page", value: String(page))
        ]

        // Make sure the URL is valid
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        // Call the network
        let (data, response) = try await URLSession.shared.data(from: url)

        // Check the HTTP status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
        }

        // Decode JSON into [Coin]
        do {
            return try JSONDecoder().decode([Coin].self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
