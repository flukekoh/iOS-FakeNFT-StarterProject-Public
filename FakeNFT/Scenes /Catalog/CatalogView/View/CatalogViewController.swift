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
        tableView.backgroundColor = .background
        tableView.separatorColor = .background
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.onChange = self.catalogTableView.reloadData
        viewModel.onError = { [weak self] error in
            self?.showErrorAlert(error: error)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showErrorAlert(error: String) {
        let alertController = UIAlertController(
            title: "alertErrorTitle",
            message: error,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "no", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "repeat", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.updateData()
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

extension CatalogViewController: UITableViewDelegate {
    
}
