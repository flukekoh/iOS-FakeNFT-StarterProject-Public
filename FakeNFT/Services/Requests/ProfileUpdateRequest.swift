import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let profileUpdateDTO: ProfileUpdateDTO
    var endpoint: URL? {
        URL(string: "https://651ff107906e276284c3c2d0.mockapi.io/api/v1/profile/1")
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
