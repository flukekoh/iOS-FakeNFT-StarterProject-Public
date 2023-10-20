import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let orderUpdateDTO: OrderUpdateDTO
    var endpoint: URL? {
        baseURL.appendingPathComponent("orders/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Encodable? {
        orderUpdateDTO
    }
}

struct OrderUpdateDTO: Encodable {
    let nfts: [String]
    let id: String
}
