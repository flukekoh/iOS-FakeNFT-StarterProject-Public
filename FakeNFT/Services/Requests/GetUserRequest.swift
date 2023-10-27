//
//  GetUserRequest.swift
//  FakeNFT
//
//  Created by Артем Кохан on 16.10.2023.
//

import Foundation

struct GetUserRequest: NetworkRequest {
    var id: String

    var endpoint: URL? {
        baseURL.appendingPathComponent("users/\(id)")
    }
}
