//
//  MyNFTViewModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 08.10.2023.
//

import Foundation


final class MyNFTViewModel {
    var onTableDataLoad: (([NFTModel]) -> Void)?
    var onError: ((Error) -> Void)?

    var tableData: [NFTModel] = [] {
        didSet {
            onTableDataLoad?(tableData)
        }
    }

    let nftNetworkSevice: NFTNetworkSevice?

    var sorting: SortingMethod? {
        didSet {
            guard let sorting else { return }
//            nftNetworkSevice.sort(by: sorting)
            nftNetworkSevice?.sorting = sorting
        }
    }
    var authorsSet: [String: String] = [:]

    private var error: Error?
    private var nftsIds: [String]
    private var likesIds: [String]


    init(nftsIds: [String]?, likesIds: [String]?) {
        self.nftsIds = nftsIds ?? []
        self.likesIds = likesIds ?? []

        nftNetworkSevice = NFTNetworkSevice(nftsIds: self.nftsIds, likesIds: self.likesIds, authorInfoNeeded: true)
        nftNetworkSevice?.delegate = self
    }

    func viewWillAppear() {
        nftNetworkSevice?.getDataByType(arrayOfIDs: nftsIds)
    }
}

extension MyNFTViewModel: NFTNetworkSeviceDelegate {
    func updateData(loadedData: [NFTModel]) {
        tableData = loadedData
    }

    func updateAuthors(authors: [String: String]) {
        authorsSet = authors
    }

    func catchError(error: Error) {
        onError?(error)
    }
}
