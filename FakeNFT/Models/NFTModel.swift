//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 12.10.2023.
//

import UIKit

struct NFTModel {
    let nftImage: String
    let name: String
    let markedFavorite: Bool
    let price: Double
    let author: String
    let rating: Int

    static let mockedNFTs: [NFTModel] = [
        NFTModel(
            nftImage: "NFT1",
            name: "Lilo",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3),
        NFTModel(
            nftImage: "NFT2",
            name: "Spring",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3),
        NFTModel(
            nftImage: "NFT1",
            name: "April",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3)
    ]
}
