//
//  MyNFTViewModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 08.10.2023.
//

import Foundation

enum SortingMethod: Codable {
    case price
    case rating
    case name
}

final class MyNFTViewModel {
    var onTableDataLoad: (([NFTModel]) -> Void)?
    var onError: ((Error) -> Void)?

    var tableData: [NFTModel] = [] {
        didSet {
            onTableDataLoad?(tableData)
        }
    }

    var sorting: SortingMethod? {
        didSet {
            guard let sorting else { return }
            sort(by: sorting)
        }
    }
    var authorsSet: [String: String] = [:]

    private var networkClient: NetworkClient = DefaultNetworkClient()
    private var error: Error?
    private var nftsIds: [String]
    private var likesIds: [String]


    init(nftsIds: [String]?, likesIds: [String]?) {
        self.nftsIds = nftsIds ?? []
        self.likesIds = likesIds ?? []
    }

    func viewWillAppear() {
        getTableData()
    }

    func getTableData() {
        let dispatchGroup = DispatchGroup()

        for id in nftsIds {
            dispatchGroup.enter()

            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.networkClient.send(request: GetNFTsRequest(id: id), type: NFTNetworkModel.self) { [weak self] result in
                    //                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) { // без задержки все время получаю ошибку 429
                    switch result {
                    case .success(let nftData):
                        DispatchQueue.main.async {
                            self?.setupTableData(response: nftData)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError?(error)
                        }
                    }
                    dispatchGroup.leave()
                    //                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.getAuthors(loadedNFTS: self.tableData)
        }
    }

    func getAuthors(loadedNFTS: [NFTModel]) {
        let dispatchGroup = DispatchGroup()
        for nft in loadedNFTS {
            dispatchGroup.enter()
            networkClient.send(request: GetUserRequest(id: nft.author), type: UserNetworkModel.self) { [weak self] result in
                DispatchQueue.global(qos: .background).async {
                    switch result {
                    case .success(let authorData):
                        DispatchQueue.main.async {
                            self?.setupAuthor(response: authorData)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError?(error)
                        }
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.sort(by: self.sorting ?? .rating)
            self.onTableDataLoad?(self.tableData)
        }
    }

    func setupTableData(response: NFTNetworkModel) {
        tableData.append(NFTModel(
            nftImage: response.images.first ?? "",
            name: response.name,
            markedFavorite: likesIds.contains(response.id),
            price: response.price,
            author: response.author,
            rating: response.rating,
            id: response.id
        )
        )
    }

    func setupAuthor(response: UserNetworkModel) {
        authorsSet.updateValue(response.name, forKey: response.id)
    }

    private func sort(by sortingMethod: SortingMethod) {
        switch sortingMethod {
        case .price:
            tableData = tableData.sorted(by: { $0.price < $1.price })
        case .rating:
            tableData = tableData.sorted(by: { $0.rating > $1.rating })
        case .name:
            tableData = tableData.sorted(by: { $0.name < $1.name })
        }
    }
}