import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let profileUpdateDTO: ProfileUpdateDTO
    var endpoint: URL? {
        baseURL.appendingPathComponent("profile/1")
    }

    var httpMethod: HttpMethod {
        .put
    }

    var dto: Encodable? {
        profileUpdateDTO
    }
}

struct ProfileUpdateDTO: Encodable {
    let likes: [String]
    let id: String
}
