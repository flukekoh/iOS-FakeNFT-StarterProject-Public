import Foundation

final class CollectionViewModel: NSObject {
    let collection: CatalogNetworkModel
    
    var user: User?
    var order: Order?
    var profile: ProfileNetworkModel?
    var nfts: [NFTNetworkModel]?
    
    var onChange: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(collection: CatalogNetworkModel) {
        self.collection = collection
        super.init()
        loadNFTData()
        loadOrderData()
        loadProfileData()
    }
    
    func reload() {
        let authorId = collection.author
        loadNFTData()
        loadOrderData()
        loadProfileData()
    }
    
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
                request: ProfileRequest(),
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
}
