import SwiftUI

struct CoinRowView: View {
    let coin: Coin

    var body: some View {
        HStack(spacing: 12) {

            // Coin image loaded from URL
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Circle().fill(.gray.opacity(0.2))
            }
            .frame(width: 36, height: 36)

            // Name and symbol
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Price and 24h change
            VStack(alignment: .trailing) {
                Text(coin.currentPrice, format: .currency(code: "USD"))
                if let change = coin.priceChangePercentage24h {
                    Text(String(format: "%.2f%%", change))
                        .font(.caption)
                        .foregroundStyle(change >= 0 ? .green : .red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CoinRowView(coin: .sample)
        .padding()
}
