//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit

final class MyNFTViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = .tableViewBackground
        tableView.layer.cornerRadius = 16

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: MyNFTCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupLayout()
    }

    private var tableData: [NFTModel] {
        return NFTModel.mockedNFTs
    }

    private func setupView() {
        title = "Мои NFT"
        view.backgroundColor = UIColor(named: "ypWhite")
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
}

extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myNFTCell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.identifier) as? MyNFTCell
        else { return UITableViewCell() }

        myNFTCell.configure(nft: tableData[indexPath.row])
        return myNFTCell
    }
}

extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

struct NFTModel {
    let nftImage: UIImage?
    let title: String
    let markedFavorite: Bool
    let price: Double
    let author: String
    let rating: Int

    static let mockedNFTs: [NFTModel] = [
        NFTModel(
            nftImage: UIImage(named: "NFT1"),
            title: "Lilo",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3),
        NFTModel(
            nftImage: UIImage(named: "NFT2"),
            title: "Spring",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3),
        NFTModel(
            nftImage: UIImage(named: "NFT1"),
            title: "April",
            markedFavorite: true,
            price: 1.78,
            author: "John Doe",
            rating: 3)
    ]
}
