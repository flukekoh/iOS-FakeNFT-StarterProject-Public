import UIKit

final class CatalogViewController: UIViewController {
    private var collections: [CatalogNetworkModel] {
        viewModel.collections
    }
    
    private let viewModel: CatalogViewModel
    
    private lazy var catalogTableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
