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

    private var networkClient: NetworkClient = DefaultNetworkClient()
    private var error: Error?

    var profile: ProfileModel? {
        didSet {
            guard let profile = profile else { return}
            onProfileLoad?(profile)
        }
    }

    func viewWillAppear() {
        getProfile()
    }

    func getProfile() {
        let request = GetProfileRequest()

        networkClient.send(request: request, type: ProfileNetworkModel.self) { [self] result in
            DispatchQueue.global(qos: .background).async {
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self.setupProfileModel(response: profile)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.onError?(error)
                    }
                }
            }
        }
    }

    func putProfile(name: String, avatar: String, description: String, website: String, likes: [String]) {
        let request = PutProfileRequest(name: name, description: description, website: website, likes: likes)

        networkClient.send(request: request, type: ProfileNetworkModel.self) { [self] result in
            DispatchQueue.global(qos: .background).async {
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self.setupProfileModel(response: profile)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.onError?(error)
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
