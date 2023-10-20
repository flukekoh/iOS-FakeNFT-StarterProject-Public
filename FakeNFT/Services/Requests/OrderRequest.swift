import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        baseURL.appendingPathComponent("orders/1")
    }
}
