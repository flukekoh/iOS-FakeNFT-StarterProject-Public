import UIKit

final class CatalogViewController: UIViewController {

    // MARK: - Private Properties

    private var collections: [CatalogNetworkModel] {
        viewModel.collections
    }

    private let viewModel: CatalogViewModel
    private let tableCellHeight = 187

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

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView(style: .medium)
        activitiIndicator.color = .textPrimary
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activitiIndicator
    }()

    // MARK: - Init

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

    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayout()
        makeNavBar()
        viewModel.onLoadingStarted = self.startAnimating
        viewModel.onLoadingFinished = self.stopAnimating
    }

    // MARK: - View Will Appear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateData()
    }

    // MARK: - Private Func

    private func startAnimating() {
        activityIndicator.startAnimating()
    }

    private func stopAnimating() {
        activityIndicator.stopAnimating()
    }

    private func addSubviews() {
        view.addSubview(catalogTableView)
        view.addSubview(activityIndicator)
        view.backgroundColor = .background
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            catalogTableView.topAnchor.constraint(equalTo: view.topAnchor),
            catalogTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            catalogTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            catalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func showErrorAlert(error: String) {
        let alertController = UIAlertController(
            title: "Ошибка",
            message: error,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Не надо", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.updateData()
        }))
        present(alertController, animated: true, completion: nil)
    }

    private func makeNavBar() {
        if let navBar = navigationController?.navigationBar {
            let righButton = UIBarButtonItem(
                image: UIImage(named: "sortButton"),
                style: .plain,
                target: self,
                action: #selector(self.didTapSortButton)
            )
            navigationItem.rightBarButtonItem = righButton
            navBar.tintColor = .textPrimary
        }
    }

    @objc private func didTapSortButton() {
        let alertSort = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.viewModel.sortByName()
        }
        let sortByNumberOfNFT = UIAlertAction(title: "По количеству NFT", style: .default) {[weak self] _ in
            self?.viewModel.sortByNFT()
        }
        let closeAlert = UIAlertAction(title: "Закрыть", style: .cancel)
        alertSort.addAction(sortByNameAction)
        alertSort.addAction(sortByNumberOfNFT)
        alertSort.addAction(closeAlert)
        present(alertSort, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collections.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let categoryCell = tableView.dequeueReusableCell(
            withIdentifier: CatalogTableViewCell.identifier) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        let collection = collections[indexPath.row]
        if let imageURLString = collection.cover,
           let imageURL = URL(string: imageURLString.encodeUrl) {
            categoryCell.configure(image: imageURL, title: collection.displayName)
        }
        categoryCell.selectionStyle = .none
        return categoryCell
    }
}

// MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableCellHeight)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionVC = NFTCollectionView(viewModel: CollectionViewModel(collection: collections[indexPath.row]))
        self.navigationController?.pushViewController(collectionVC, animated: true)
    }
}

extension String {
    var encodeUrl: String {
        guard let adding = self.addingPercentEncoding(
            withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return "" }
        return adding
    }
    var decodeUrl: String {
        guard let removing = self.removingPercentEncoding else { return ""}
        return removing
    }
}
