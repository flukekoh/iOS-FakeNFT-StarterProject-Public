import Foundation

struct CollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        baseURL.appendingPathComponent("collections")
    }
}
