# CryptoTracker...

A clean, modern iOS app that tracks cryptocurrency market data, built with **SwiftUI** and a testable architecture based on **MVVM**, the **Repository pattern**, and **Dependency Injection**.

![Platform](https://img.shields.io/badge/platform-iOS%2017%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6-orange)
![UI](https://img.shields.io/badge/UI-SwiftUI-green)
![Architecture](https://img.shields.io/badge/architecture-MVVM-purple)

## Features

- Live cryptocurrency market data from the [CoinGecko API](https://www.coingecko.com/en/api)
- Search coins by name or symbol
- Infinite scrolling with pagination
- Loading, error, and empty states
- Async/await networking with `URLSession`
- Fully testable: Mock repository for previews and unit tests

 

## Architecture

The app follows **MVVM** with a **Repository** layer between the ViewModel and the data source. Dependencies are injected from a single composition root.

```
View  →  ViewModel  →  CoinRepository (protocol)
                              ↑
                 ┌────────────┴────────────┐
       DefaultCoinRepository        MockCoinRepository
        (real API calls)           (fake data for tests)
                 │
          CoinAPIService
        (URLSession + async/await)
```

### Why this structure?

| Concept | Benefit |
|---|---|
| **MVVM** | Separates UI from business logic |
| **Repository pattern** | ViewModel does not know where data comes from (API, cache, database) |
| **Dependency Injection** | Dependencies are passed in, not created inside, so they are easy to replace |
| **Protocol-based design** | Allows mock implementations for previews and tests |

## Project Structure

```
CryptoTracker/
├── App/
│   └── CryptoTrackerApp.swift      # Composition root (creates real objects)
├── Models/
│   └── Coin.swift                  # Codable model
├── Networking/
│   ├── CoinAPIService.swift        # URLSession + async/await
│   └── NetworkError.swift          # Custom error types
├── Repositories/
│   ├── CoinRepository.swift        # Protocol + default implementation
│   └── MockCoinRepository.swift    # Fake data for previews and tests
├── ViewModels/
│   └── CoinListViewModel.swift     # State, search, pagination logic
└── Views/
    ├── CoinListView.swift          # Main list screen
    └── CoinRowView.swift           # Single coin row
```

## Tech Stack

- **Language:** Swift
- **UI:** SwiftUI
- **State management:** Observation framework (`@Observable`)
- **Concurrency:** async/await, `@MainActor`
- **Networking:** URLSession
- **Testing:** Swift Testing
- **API:** CoinGecko (free, no API key required)

## Getting Started

### Requirements

- Xcode 16 or later
- iOS 17.0 or later

### Run the project

```bash
git clone https://github.com/<your-username>/CryptoTracker.git
cd CryptoTracker
open CryptoTracker.xcodeproj
```

Select a simulator and press `Cmd + R`.

> **Note:** The free CoinGecko API has a rate limit. If you see a `429` error in the console, wait a minute and try again.

## Testing

Run all unit tests with `Cmd + U`.

The ViewModel is tested using `MockCoinRepository`, so tests run instantly without internet access. Covered cases:

- Loading the first page
- Error handling
- Search filtering
- Pagination (appending the next page)

## Key Implementation Details

**Pagination:** The ViewModel tracks `currentPage` and loads the next page when the user scrolls near the last 5 items. New coins are appended to the existing list.

**Dependency Injection:** `CoinListViewModel` receives a `CoinRepository` through its initializer. The real repository is created only once, in `CryptoTrackerApp`.

```swift
// Production
CoinListViewModel(repository: DefaultCoinRepository())

// Preview and tests
CoinListViewModel(repository: MockCoinRepository.withSampleCoins())
```

## Roadmap

- [ ] Server-side search using the CoinGecko `/search` endpoint
- [ ] Coin detail screen with price chart
- [ ] Pull-to-refresh
- [ ] Local caching (offline support)
- [ ] Favorites

## Acknowledgements

- Market data provided by [CoinGecko](https://www.coingecko.com)

## Author

**Ramim Hossain**
GitHub: [@ramimhossain12](https://github.com/ramimhossain12)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
