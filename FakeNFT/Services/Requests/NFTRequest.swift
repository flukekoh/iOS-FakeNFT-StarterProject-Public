import Foundation

struct NFTRequest: NetworkRequest {
    var endpoint: URL? {
        baseURL.appendingPathComponent("nft")
    }
}
