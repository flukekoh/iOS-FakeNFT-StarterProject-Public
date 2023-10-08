//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Артем Кохан on 06.10.2023.
//

import Foundation
import UIKit

final class ProfileViewModel {
    var onProfileLoad: ((ProfileModel) -> Void)?
    
    private var networkClient: NetworkClient = DefaultNetworkClient()
    private var error: Error?
    
    private var profile: ProfileModel? {
        didSet {
            guard let profile = profile else { return}
            onProfileLoad?(profile)
        }
    }
    
    func viewWillAppear() {
       getProfile()
    }
    
    func getProfile()  {
        
        let request = GetProfileRequest()
        
        networkClient.send(request: request, type: ProfileNetworkModel.self) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.setupProfileModel(response: profile)
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func putProfile(name: String, avatar: String, description: String, website: String, likes: [String]) {
        
        guard let profile = profile else { return }
        
        let request = PutProfileRequest(profile: profile)
            
        networkClient.send(request: request, type: ProfileNetworkModel.self) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.setupProfileModel(response: profile)
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func setupProfileModel(response: ProfileNetworkModel) {
        //URL(string: response.avatar)
        let profileModel = ProfileModel(name: response.name, avatar: response.avatar, description: response.description, website: response.website, nfts: response.nfts, likes: response.likes, id: response.id)
        self.profile = profileModel
    }
}

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL? {
//        URL(string: "INSERT_URL_HERE")
        baseURL.appendingPathComponent("profile/1")
    }
}

struct PutProfileRequest: NetworkRequest {
    struct Body: Encodable {
        let name: String
        let avatar: String
        let description: String
        let website: String
    }
    
    var endpoint: URL? {
        baseURL.appendingPathComponent("profile/1")
    }
    
    var httpMethod: HttpMethod = .put
    
    var body: Data?
    
    init(profile: ProfileModel) {
        self.body = try? JSONEncoder().encode(Body(
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website
        ))
    }
}
