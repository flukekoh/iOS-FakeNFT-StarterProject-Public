//
//  PutProfileRequest.swift
//  FakeNFT
//
//  Created by Артем Кохан on 12.10.2023.
//

import Foundation

struct PutProfileRequest: NetworkRequest {
    var dto: Encodable?

    struct Body: Encodable {
        let name: String?
        let avatar: String?
        let description: String?
        let website: String?
        let likes: [String]?
    }

    var endpoint: URL? {
        baseURL.appendingPathComponent("profile/1")
    }

    var httpMethod: HttpMethod = .put

    init(name: String?, avatar: String?, description: String?, website: String?, likes: [String]?) {
        self.dto = Body(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes)
    }
}
