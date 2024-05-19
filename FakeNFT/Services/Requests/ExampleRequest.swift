import Foundation

struct ExampleRequest: NetworkRequest {
    var endpoint: URL? {
        baseURL.appendingPathComponent(":endpoint")
    }
}
