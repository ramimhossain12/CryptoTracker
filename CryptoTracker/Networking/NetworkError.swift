import Foundation

enum NetworkError: Error {
    case invalidURL
    case badResponse(statusCode: Int)
    case decodingFailed
    case unknown
}
