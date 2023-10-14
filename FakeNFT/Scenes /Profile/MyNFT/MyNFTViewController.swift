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

        tableView.backgroundColor = UIColor(named: "ypWhite")
        tableView.layer.cornerRadius = 16

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: MyNFTCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myNFTViewModel.viewWillAppear()
    }

    private var tableData: [NFTModel] = []
//    {
//        return NFTModel.mockedNFTs
//    }

    private func setupView() {
        title = "Мои NFT"
        view.backgroundColor = UIColor(named: "ypWhite")

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = customBackButton
        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupHierarchy() {
        view.addSubview(tableView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    }

    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func sortTable() {
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

        myNFTCell.configure(nft: myNFT)
        return myNFTCell
    }
}

extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
