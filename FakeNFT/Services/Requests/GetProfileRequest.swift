import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        baseURL.appendingPathComponent("profile/1")
    }
}
