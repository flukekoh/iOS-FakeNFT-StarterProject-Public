//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 12.10.2023.
//

import UIKit

struct NFTModel {
    let nftImage: UIImage?
    let title: String
    let markedFavorite: Bool
    let price: Double
    let author: String
    let rating: Int

    static let mockedNFTs: [NFTModel] = [
        NFTModel(
            nftImage: UIImage(named: "NFT1"),
            title: "Lilo",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3),
        NFTModel(
            nftImage: UIImage(named: "NFT2"),
            title: "Spring",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3),
        NFTModel(
            nftImage: UIImage(named: "NFT1"),
            title: "April",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3)
    ]
}
