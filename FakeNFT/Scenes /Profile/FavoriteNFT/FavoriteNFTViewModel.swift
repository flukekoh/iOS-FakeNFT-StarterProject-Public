//
//  FavoriteNFTViewModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 08.10.2023.
//

import Foundation

final class FavoriteNFTViewModel {
    var onCollectionDataLoad: (([NFTModel]) -> Void)?
    var onError: ((Error) -> Void)?

    var collectionData: [NFTModel] = [] {
        didSet {
            onCollectionDataLoad?(collectionData)
        }
    }

    var authorsSet: [String: String] = [:]

    private var networkClient: NetworkClient = DefaultNetworkClient()
    private var error: Error?
    private var nftsIds: [String]
    var likesIds: [String]

    let nftNetworkSevice: NFTNetworkSevice?

    init(nftsIds: [String]?, likesIds: [String]?) {
        self.nftsIds = nftsIds ?? []
        self.likesIds = likesIds ?? []

        nftNetworkSevice = NFTNetworkSevice(nftsIds: self.nftsIds, likesIds: self.likesIds, authorInfoNeeded: false)
        nftNetworkSevice?.delegate = self
    }

    func viewWillAppear() {
        nftNetworkSevice?.getDataByType(arrayOfIDs: likesIds)
    }
}

extension FavoriteNFTViewModel: NFTNetworkSeviceDelegate {
    func updateData(loadedData: [NFTModel]) {
        collectionData = loadedData
    }

    func updateAuthors(authors: [String: String]) {
        authorsSet = authors
    }

    func catchError(error: Error) {
        onError?(error)
    }
}
