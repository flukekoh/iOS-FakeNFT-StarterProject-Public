//
//  PutProfileRequest.swift
//  FakeNFT
//
//  Created by Артем Кохан on 12.10.2023.
//

import Foundation

struct PutProfileRequest: NetworkRequest {
    struct Body: Encodable {
        let name: String
        let description: String
        let website: String
        let likes: [String]
    }

    var endpoint: URL? {
        baseURL.appendingPathComponent("profile/1")
    }

    var httpMethod: HttpMethod = .put
    var body: Data?

    init(name: String, description: String, website: String, likes: [String]) {
        self.body = try? JSONEncoder().encode(Body(
            name: name,
            description: description,
            website: website,
            likes: likes))
    }
}
