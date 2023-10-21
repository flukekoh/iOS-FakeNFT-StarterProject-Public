//
//  FavoriteNFTViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit

final class FavoriteNFTViewController: UIViewController {
    private lazy var customBackButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "BackButton"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        return uiBarButtonItem
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width / 2) - 30, height: 142)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 50)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.register(
            FavoriteNFTCell.self,
            forCellWithReuseIdentifier: FavoriteNFTCell.identifier
        )

        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupLayout()
    }

    private var collectionData: [NFTModel] {
        return NFTModel.mockedNFTs
    }

    private func setupView() {
        title = "Избранные NFT"
        view.backgroundColor = UIColor(named: "ypWhite")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = customBackButton
    }

    private func setupHierarchy() {
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension FavoriteNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FavoriteNFTCell.identifier,
                for: indexPath
            ) as? FavoriteNFTCell
        else {
            return UICollectionViewCell()
        }
        let currentNFT = collectionData[indexPath.row]
        cell.configure(nft: currentNFT)
        
        return cell
    }
}

extension FavoriteNFTViewController: UICollectionViewDelegate {
}
