import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        baseURL.appendingPathComponent("profile/1")
    }
}
