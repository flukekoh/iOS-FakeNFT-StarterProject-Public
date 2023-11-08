import Foundation

let baseURL = URL(string: "https://651ff107906e276284c3c2d0.mockapi.io/api/v1")!

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRequest {
    var endpoint: URL? { get }
    var httpMethod: HttpMethod { get }
    var dto: Encodable? { get }
}

// default values
extension NetworkRequest {
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}

struct DefaultNetworkRequest: NetworkRequest {
    let endpoint: URL?
    let dto: Encodable?
    let httpMethod: HttpMethod
}
