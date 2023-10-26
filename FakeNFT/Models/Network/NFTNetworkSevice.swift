//
//  NFTNetworkSevice.swift
//  FakeNFT
//
//  Created by Артем Кохан on 22.10.2023.
//

import Foundation

enum SortingMethod: Codable {
    case price
    case rating
    case name
}

protocol NFTNetworkSeviceDelegate {
    func updateData(loadedData: [NFTModel])
    func updateAuthors(authors: [String: String])
    func catchError(error: Error)
}

final class NFTNetworkSevice {
    var authorsSet: [String: String] = [:]
    var tableData: [NFTModel] = []
    var delegate: NFTNetworkSeviceDelegate?
    var sorting: SortingMethod? {
        didSet {
            guard let sorting else { return }
            sort(by: sorting)
        }
    }

    private let networkClient: NetworkClient = DefaultNetworkClient()
    private var nftsIds: [String]
    private var likesIds: [String]
    private var authorInfoNeeded: Bool

    init(nftsIds: [String], likesIds: [String], authorInfoNeeded: Bool) {
        self.nftsIds = nftsIds
        self.likesIds = likesIds
        self.authorInfoNeeded = authorInfoNeeded
    }

    func getDataByType(arrayOfIDs: [String]) {
        let group = DispatchGroup()

        for id in arrayOfIDs {
            group.enter()
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3) {
                self.networkClient.send(request: GetNFTsRequest(id: id), type: NFTNetworkModel.self) { [weak self] result in
                    switch result {
                    case .success(let nftData):
                        DispatchQueue.main.async {
                            self?.setupTableData(response: nftData)
                            group.leave()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.delegate?.catchError(error: error)
                            group.leave()
                        }
                    }
                }
            }
        }

        group.notify(queue: .main) {
            if self.authorInfoNeeded {
                self.getAuthors(loadedNFTS: self.tableData)
            } else {
                self.sort(by: self.sorting ?? .rating)
            }

            self.delegate?.updateData(loadedData: self.tableData)
        }
    }

    func getAuthors(loadedNFTS: [NFTModel]) {
        let group = DispatchGroup()
        for nft in loadedNFTS {
            group.enter()
            DispatchQueue.global(qos: .background).async {
                self.networkClient.send(request: GetUserRequest(id: nft.author), type: UserNetworkModel.self) { [weak self] result in
                    switch result {
                    case .success(let authorData):
                        DispatchQueue.main.async {
                            self?.setupAuthor(response: authorData)
                            group.leave()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.delegate?.catchError(error: error)
                            group.leave()
                        }
                    }
                }
            }
        }

        group.notify(queue: .main) {
            self.delegate?.updateAuthors(authors: self.authorsSet)
            self.sort(by: self.sorting ?? .rating)
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
