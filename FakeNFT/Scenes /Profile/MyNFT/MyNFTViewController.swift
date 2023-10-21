//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit
import ProgressHUD

final class MyNFTViewController: UIViewController {
    private var myNFTViewModel: MyNFTViewModel

    private lazy var customBackButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "BackButton"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        return uiBarButtonItem
    }()

    private lazy var sortButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "sortButton"),
            style: .plain,
            target: self,
            action: #selector(sortTable)
        )
        return uiBarButtonItem
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = .background
        tableView.layer.cornerRadius = 16
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: MyNFTCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let noNFTLabel: UILabel = {
        let noNFTLabel = UILabel()
        noNFTLabel.text = "У Вас ещё нет NFT"
        noNFTLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        noNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        noNFTLabel.textColor = .black

        return noNFTLabel
    }()

    private let tableCellHeight: CGFloat = 140

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        ProgressHUD.show()
        setupHierarchy()
        setupLayout()

        myNFTViewModel.onTableDataLoad = { [weak self] tableData in
            guard let self else { return }

            self.setupTableData(tableData: tableData)
            ProgressHUD.dismiss()
        }

        myNFTViewModel.onError = { [weak self] error in
            guard let self else { return }
            self.showAlert(title: "Ошибка", message: error.localizedDescription)

            ProgressHUD.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myNFTViewModel.viewWillAppear()

        if let sortingMethod = UserDefaults.standard.data(forKey: "sortingMethod") {
            let sortingMethod = try? PropertyListDecoder().decode(SortingMethod.self, from: sortingMethod)
            self.myNFTViewModel.sorting = sortingMethod
        } else {
            self.myNFTViewModel.sorting = .rating
        }
    }

    private var tableData: [NFTModel] = []


    private func setupView() {
        view.backgroundColor = .background

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = customBackButton
    }

    private func setupNoNFT() {
        if tableData.isEmpty {
            noNFTLabel.isHidden = false
        } else {
            title = "Мои NFT"

            navigationItem.rightBarButtonItem = sortButton
            noNFTLabel.isHidden = true
        }
    }

    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(noNFTLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    init(myNFTViewModel: MyNFTViewModel) {
        self.myNFTViewModel = myNFTViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableData(tableData: [NFTModel]) {
        self.tableData = tableData
        tableView.reloadData()

        setupNoNFT()
    }

    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func sortTable() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet
        )

        let sortByPriceAction = UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
            self?.myNFTViewModel.sorting = .price
            self?.saveSortingOrder(sortingMethod: .price)
        }
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.myNFTViewModel.sorting = .rating
            self?.saveSortingOrder(sortingMethod: .rating)
        }
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
            self?.myNFTViewModel.sorting = .name
            self?.saveSortingOrder(sortingMethod: .name)
        }
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel)

        alert.addAction(sortByPriceAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(sortByNameAction)
        alert.addAction(closeAction)

        present(alert, animated: true)
    }

    private func saveSortingOrder(sortingMethod: SortingMethod) {
        let data = try? PropertyListEncoder().encode(sortingMethod)
        UserDefaults.standard.set(data, forKey: "sortingMethod")
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myNFTCell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.identifier) as? MyNFTCell
        else { return UITableViewCell() }

        let myNFT = tableData[indexPath.row]

        myNFTCell.configure(nft: NFTModel(
            nftImage: myNFT.nftImage,
            name: myNFT.name,
            markedFavorite: myNFT.markedFavorite,
            price: myNFT.price,
            author: myNFTViewModel.authorsSet[myNFT.author] ?? "",
            rating: myNFT.rating)
        )
        return myNFTCell
    }
}

extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableCellHeight
    }
}
