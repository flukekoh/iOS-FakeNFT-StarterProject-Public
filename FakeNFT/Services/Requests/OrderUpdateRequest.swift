import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let orderUpdateDTO: OrderUpdateDTO
    var endpoint: URL? {
        URL(string: "https://651ff107906e276284c3c2d0.mockapi.io/api/v1/orders/1")
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
