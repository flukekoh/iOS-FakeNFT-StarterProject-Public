import Foundation

final class CatalogViewModel: NSObject {

    private let sortManager = SortManager()
    private(set) var collections: [CatalogNetworkModel] = []
    var onChange: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStarted: (() -> Void)?
    var onLoadingFinished: (() -> Void)?

    override init() {
        super.init()
    }

    func updateData() {
        loadData()
    }

    private func loadData() {
        let sort = sortManager.getSortValue()
        onLoadingStarted?()
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(
                request: CollectionsRequest(),
                type: [CatalogNetworkModel].self
            ) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.collections = data
                    DispatchQueue.main.async {
                        if sort == SortType.byName.rawValue {
                            self?.sortByName()
                        } else {
                            self?.sortByNFT()
                        }
                        self?.onLoadingFinished?()
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

    func sortByName() {
        collections = collections.sorted {
            $0.name < $1.name
        }
        sortManager.setSortValue(value: SortType.byName.rawValue)
        onChange?()
    }

    func sortByNFT() {
        collections = collections.sorted {
            $0.nfts.count > $1.nfts.count
        }
        sortManager.setSortValue(value: SortType.byNFT.rawValue)
        onChange?()
    }
}
