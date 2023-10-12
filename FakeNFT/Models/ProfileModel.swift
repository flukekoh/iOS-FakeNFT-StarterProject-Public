//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 08.10.2023.
//

import Foundation

class ProfileModel {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String

    init(name: String, avatar: String, description: String, website: String, nfts: [String], likes: [String], id: String) {
        self.name = name
        self.avatar = avatar
        self.description = description
        self.website = website
        self.nfts = nfts
        self.likes = likes
        self.id = id
    }
}
