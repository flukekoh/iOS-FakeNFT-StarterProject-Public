//
//  MyNFTViewModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 08.10.2023.
//

import Foundation

class MyNFTViewModel {
    var onTableDataLoad: (([NFTModel]) -> Void)?
    var onError: ((Error) -> Void)?

    private var networkClient: NetworkClient = DefaultNetworkClient()
    private var error: Error?
    private var nftsIds: [String]

    var tableData: [NFTModel] = [] {
        didSet {
            onTableDataLoad?(tableData)
        }
    }

    init(nftsIds: [String]?) {
        self.nftsIds = nftsIds ?? []
    }

    func viewWillAppear() {
        getTableData()
    }

    func getTableData() {
        for id in nftsIds {
            networkClient.send(request: GetNFTsRequest(id: id), type: NFTNetworkModel.self) { [self] result in
                DispatchQueue.global(qos: .background).async {
                    switch result {
                    case .success(let nftData):
                        DispatchQueue.main.async {
                            self.setupTableData(response: nftData)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.onError?(error)
                        }
                    }
                }
            }
        }
    }

    func setupTableData(response: NFTNetworkModel) {
        tableData.append(NFTModel(
            nftImage: response.images[0],
            name: response.name,
            markedFavorite: true,
            price: response.price,
            author: response.author,
            rating: response.rating
        )
        )
    }
}
