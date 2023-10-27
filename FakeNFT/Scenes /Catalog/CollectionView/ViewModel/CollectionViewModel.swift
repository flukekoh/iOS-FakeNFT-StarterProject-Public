import Foundation

final class CollectionViewModel: NSObject {
    // MARK: - Properties

    let collection: CatalogNetworkModel

    var user: User?
    var order: Order?
    var profile: ProfileNetworkModel?
    var nfts: [NFTNetworkModel]?

    var onChange: (() -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Init

    init(collection: CatalogNetworkModel) {
        self.collection = collection
        super.init()
        loadAuthorData(id: collection.author)
        loadNFTData()
        loadOrderData()
        loadProfileData()
    }

    // MARK: - Func

    func reload() {
        loadNFTData()
        loadOrderData()
        loadProfileData()
    }

    func toggleLikeForNFT(with id: String) {
        var likes = profile?.likes
        if let index = likes?.firstIndex(of: id) {
            likes?.remove(at: index)
        } else {
            likes?.append(id)
        }
        guard let likes = likes,
              let id = profile?.id else { return }
        let dto = ProfileUpdateDTO(likes: likes, id: id)
        updateProfileData(with: dto)
    }

    func toggleCartForNFT(with id: String) {
        var nfts = order?.nfts
        if let index = nfts?.firstIndex(of: id) {
            nfts?.remove(at: index)
        } else {
            nfts?.append(id)
        }
        guard let nfts = nfts,
              let id = order?.id else { return }
        let dto = OrderUpdateDTO(nfts: nfts, id: id)
        updateOrderData(with: dto)
    }

    // MARK: - Private Func


    private func loadAuthorData(id: String) {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(
                request: UserByIdRequest(userId: id),
                type: UserNetworkModel.self) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.user = User(with: data)
                        DispatchQueue.main.async {
                            self?.onChange?()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError?(error.localizedDescription)
                        }
                    }
            }
        }
    }

    private func loadNFTData() {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(
                request: NFTRequest(),
                type: [NFTNetworkModel].self) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.nfts = data.map { $0 }
                        DispatchQueue.main.async {
                            self?.onChange?()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError?(error.localizedDescription)
                        }
                    }
            }
        }
    }

    private func loadOrderData() {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(
                request: OrderRequest(),
                type: OrderNetworkModel.self) {[weak self] result in
                    switch result {
                    case .success(let data):
                        self?.order = Order(with: data)
                        DispatchQueue.main.async {
                            self?.onChange?()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError?(error.localizedDescription)
                        }
                    }
            }
        }
    }

    private func loadProfileData() {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(
                request: GetProfileRequest(),
                type: ProfileNetworkModel.self) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.profile = data
                        DispatchQueue.main.async {
                            self?.onChange?()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError?(error.localizedDescription)
                        }
                    }
            }
        }
    }

    private func updateProfileData(with dto: ProfileUpdateDTO) {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(
                request: ProfileUpdateRequest(profileUpdateDTO: dto),
                type: ProfileNetworkModel.self) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.profile = data
                        DispatchQueue.main.async {
                            self?.onChange?()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError?(error.localizedDescription)
                        }
                    }
            }
        }
    }

    private func updateOrderData(with dto: OrderUpdateDTO) {
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(
                request: OrderUpdateRequest(orderUpdateDTO: dto),
                type: OrderNetworkModel.self) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.order = Order(with: data)
                        DispatchQueue.main.async {
                            self?.onChange?()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError?(error.localizedDescription)
                        }
                    }
            }
        }
    }
}

// MARK: - Extension

extension CollectionViewModel {
    func nfts(by id: String) -> NFTNetworkModel? {
        nfts?.first { $0.id == id }
    }

    func isNFTInOrder(with nftId: String) -> Bool {
        return order?.nfts.contains(nftId) ?? false
    }

    func isNFTLiked(with nftId: String) -> Bool {
        return profile?.likes.contains(nftId) ?? false
    }
}

extension Float {
    var asETHCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "ETH"
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
