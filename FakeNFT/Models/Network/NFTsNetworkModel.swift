//
//  NFTsNetworkModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 14.10.2023.
//

import Foundation

struct NFTNetworkModel: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
