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
    var collectionData: [NFTModel] = []
    var likesIds: [String] {
        didSet {
            onCollectionDataLoad?(collectionData.filter { likesIds.contains($0.id) })
        }
    }
    var authorsSet: [String: String] = [:]

    private var error: Error?
    private var nftsIds: [String]
    private let nftNetworkSevice: NFTNetworkSevice?

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
        onCollectionDataLoad?(collectionData)
    }

    func updateAuthors(authors: [String: String]) {
        authorsSet = authors
    }

    func catchError(error: Error) {
        onError?(error)
    }
}
