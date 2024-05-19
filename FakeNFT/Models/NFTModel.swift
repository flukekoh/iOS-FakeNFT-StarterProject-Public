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
    let price: Float
    let author: String
    let rating: Int
    let id: String

    static let mockedNFTs: [NFTModel] = [
        NFTModel(
            nftImage: "NFT1",
            name: "Lilo",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3,
            id: "1"),
        NFTModel(
            nftImage: "NFT2",
            name: "Spring",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3,
            id: "2"),
        NFTModel(
            nftImage: "NFT1",
            name: "April",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3,
            id: "3")
    ]
}
