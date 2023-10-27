//
//  GetNFTsRequest.swift
//  FakeNFT
//
//  Created by Артем Кохан on 14.10.2023.
//

import Foundation

struct GetNFTsRequest: NetworkRequest {
    var id: String

    var endpoint: URL? {
        baseURL.appendingPathComponent("nft/\(id)")
    }
}
