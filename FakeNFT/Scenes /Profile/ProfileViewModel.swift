//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 06.10.2023.
//

import Foundation
import UIKit

class ProfileViewModel {
    var onProfileLoad: ((ProfileModel) -> Void)?
    var onError: ((Error) -> Void)?
    var profile: ProfileModel? {
        didSet {
            guard let profile = profile else { return}
            onProfileLoad?(profile)
        }
    }
    private var networkClient: NetworkClient = DefaultNetworkClient()
    private var error: Error?

    func viewWillAppear() {
        getProfile()
    }

    func getProfile() {
        let request = GetProfileRequest()

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.networkClient.send(request: request, type: ProfileNetworkModel.self) { result in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self?.setupProfileModel(response: profile)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error)
                    }
                }
            }
        }
    }

    func putProfile(
        name: String?,
        avatar: String?,
        description: String?,
        website: String?,
        likes: [String]?
    ) {
        let request = PutProfileRequest(
            name: name,
            avatar: avatar,
            description: description,
            website: website,
            likes: likes
        )

        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.networkClient.send(request: request, type: ProfileNetworkModel.self) { result in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self?.setupProfileModel(response: profile)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error)
                    }
                }
            }
        }
    }

    func setupProfileModel(response: ProfileNetworkModel) {
        let profileModel = ProfileModel(
            name: response.name,
            avatar: response.avatar,
            description: response.description,
            website: response.website,
            nfts: response.nfts,
            likes: response.likes,
            id: response.id)
        self.profile = profileModel
    }
}
