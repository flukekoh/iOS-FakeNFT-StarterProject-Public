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
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    private let noNFTLabel: UILabel = {
        let noNFTLabel = UILabel()
        noNFTLabel.text = "У Вас ещё нет NFT"
        noNFTLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        noNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        noNFTLabel.textColor = .black
        
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
        setupHierarchy()
        setupLayout()
        
        favoriteNFTViewModel.onCollectionDataLoad = { [weak self] collectionData in
            guard let self else { return }
            
            self.setupCollectionData(collectionData: collectionData)
            ProgressHUD.dismiss()
        }
        
        favoriteNFTViewModel.onError = { [weak self] error in
            guard let self else { return }
            self.showAlert(title: "Ошибка", message: error.localizedDescription)
            
            ProgressHUD.dismiss()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteNFTViewModel.viewWillAppear()
    }
    
    private var collectionData: [NFTModel] = []
    
    private func setupView() {
        title = "Избранные NFT"
        view.backgroundColor = .background
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
    
    private func setupNoNFT() {
        if collectionData.isEmpty {
            noNFTLabel.isHidden = false
        } else {
            title = "Избранные NFT"
            
            noNFTLabel.isHidden = true
        }
    }
    
    private func setupCollectionData(collectionData: [NFTModel]) {
        self.collectionData = collectionData
        collectionView.reloadData()
        
        setupNoNFT()
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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

extension FavoriteNFTViewController: UICollectionViewDelegate {
}

extension FavoriteNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 7
        return CGSize(width: availableWidth / 2, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
}