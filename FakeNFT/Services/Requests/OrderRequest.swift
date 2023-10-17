import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://651ff107906e276284c3c2d0.mockapi.io/api/v1/orders/1")
    }
}
