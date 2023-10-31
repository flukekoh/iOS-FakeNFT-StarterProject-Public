//
//  FavoriteNFTViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit
import ProgressHUD
import Kingfisher

final class FavoriteNFTViewController: UIViewController {
    private var favoriteNFTViewModel: FavoriteNFTViewModel
    private let profileViewModel: ProfileViewModel
    private let baseInset: CGFloat = 16
    private let sectionSpacing: CGFloat = 7
    private let lineSpacing: CGFloat = 20
    private let itemHeight: CGFloat = 80

    private lazy var customBackButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "BackButton"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        uiBarButtonItem.tintColor = .ypBlack
        return uiBarButtonItem
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .ypWhite
        view.register(
            FavoriteNFTCell.self,
            forCellWithReuseIdentifier: FavoriteNFTCell.identifier
        )
        view.tintColor = .ypWhite
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.refreshControl = refreshControl

        return view
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        return refreshControl
    }()

    private let noNFTLabel: UILabel = {
        let noNFTLabel = UILabel()
        noNFTLabel.text = "У Вас ещё нет избранных NFT"
        noNFTLabel.font = .bodyBold
        noNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        noNFTLabel.textColor = .ypBlack
        noNFTLabel.isHidden = true

        return noNFTLabel
    }()

    init(favoriteNFTViewModel: FavoriteNFTViewModel, profileViewModel: ProfileViewModel) {
        self.favoriteNFTViewModel = favoriteNFTViewModel
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        ProgressHUD.show()
        setupHierarchy()
        setupLayout()

        favoriteNFTViewModel.onCollectionDataLoad = { [weak self] collectionData in
            guard let self else { return }

            self.setupCollectionData(collectionData: collectionData)
        }

        favoriteNFTViewModel.onError = { [weak self] error in
            guard let self else { return }
            self.showAlert(title: "Ошибка", message: error.localizedDescription)

            setupNoNFT()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        refreshControl.beginRefreshing()
        collectionView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)

        refreshData()
    }

    private var collectionData: [NFTModel] = []

    private func setupView() {
        title = "Избранные NFT"
        view.backgroundColor = .ypWhite
        view.tintColor = .ypWhite
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem = customBackButton
    }

    private func setupHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(noNFTLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    private func setupNoNFT() {
        if collectionData.isEmpty {
            noNFTLabel.isHidden = false
        } else {
            title = "Избранные NFT"
            noNFTLabel.isHidden = true
        }
        ProgressHUD.dismiss()
    }

    private func setupCollectionData(collectionData: [NFTModel]) {
        self.collectionData = collectionData
        collectionView.reloadData()

        setupNoNFT()
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc
    func refreshData() {
        favoriteNFTViewModel.viewDidAppear()
        refreshControl.endRefreshing()
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

        cell.favoriteNFTViewModel = favoriteNFTViewModel
        cell.profileViewModel = profileViewModel

        cell.currentNFT = collectionData[indexPath.row]

        cell.configure()

        return cell
    }
}

extension FavoriteNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - baseInset * 2 - sectionSpacing
        return CGSize(width: availableWidth / 2, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: baseInset, bottom: baseInset, right: baseInset)
    }
}
