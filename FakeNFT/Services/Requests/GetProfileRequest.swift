//
//  GetProfileRequest.swift
//  FakeNFT
//
//  Created by Артем Кохан on 12.10.2023.
//

import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
        baseURL.appendingPathComponent("profile/1")
    }
}
