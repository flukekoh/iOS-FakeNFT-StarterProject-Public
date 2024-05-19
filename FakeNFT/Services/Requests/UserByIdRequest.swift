import Foundation

struct UserByIdRequest: NetworkRequest {
    let userId: String
    var endpoint: URL? {
        baseURL.appendingPathComponent("users/\(userId)")
    }
}
