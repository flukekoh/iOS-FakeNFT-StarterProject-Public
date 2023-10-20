import UIKit

final class NFTCollectionView: UIViewController {

    // MARK: - Private Properties

    private let viewModel: CollectionViewModel

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ImageCollectionCell.self,
            forCellWithReuseIdentifier: ImageCollectionCell.identifier
        )
        collectionView.register(
            DescriptionCollectionCell.self,
            forCellWithReuseIdentifier: DescriptionCollectionCell.identifier
        )
        collectionView.register(
            CatalogNFTCell.self,
            forCellWithReuseIdentifier: CatalogNFTCell.identifier
        )
        return collectionView
    }()

    // MARK: - Init

    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.onChange = self.collectionView.reloadData
        viewModel.onError = { [weak self] error in
            self?.showErrorAlert(error: error)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        addSubviews()
        setupLayout()
        makeNavBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reload()
    }

    // MARK: - Private Func

    private func addSubviews() {
        view.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func makeNavBar() {
        if let navBar = navigationController?.navigationBar {
            let imageButton = UIImage(systemName: "chevron.backward")?
                .withTintColor(.ypBlack ?? .black)
                .withRenderingMode(.alwaysOriginal)
            let leftButton = UIBarButtonItem(
                image: imageButton,
                style: .plain,
                target: self,
                action: #selector(self.didTapBackButton)
            )
            navigationItem.leftBarButtonItem = leftButton
            navBar.tintColor = .textPrimary
            navBar.isTranslucent = true
        }
    }

    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    private func linkAction() {
        let webViewVC = WebViewView()
        guard let url = URL(string: viewModel.user?.website ?? "") else { return }
        webViewVC.url = url
        self.navigationController?.pushViewController(webViewVC, animated: true)
    }

    private func likeOrDislikeButtonTapped(idNFT: String) {
        viewModel.toggleLikeForNFT(with: idNFT)
    }

    private func cartButtonTapped(idNFT: String) {
        viewModel.toggleCartForNFT(with: idNFT)
    }

    private func showErrorAlert(error: String) {
        let alertController = UIAlertController(
            title: "Ошибка",
            message: error,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: "Не надо",
            style: .default,
            handler: nil
        ))
        alertController.addAction(UIAlertAction(
            title: "Повторить",
            style: .default,
            handler: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.reload()
            }))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension NFTCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch section {
        case .image:
            guard let imageCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionCell.identifier,
                for: indexPath) as? ImageCollectionCell else { return UICollectionViewCell() }

            if let imageURLString = viewModel.collection.cover,
               let imageURL = URL(string: imageURLString.encodeUrl) {
                imageCell.imageView.kf.setImage(with: imageURL)
            }
            return imageCell
        case .description:
            guard let descriptionCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DescriptionCollectionCell.identifier,
                for: indexPath) as? DescriptionCollectionCell else { return UICollectionViewCell() }
            descriptionCell.configure(
                title: viewModel.collection.name,
                subTitle: "Автор коллекции: ",
                description: viewModel.collection.description,
                buttonTitle: viewModel.user?.name ?? "",
                buttonAction: linkAction)
            return descriptionCell
        case .collection:
            var likeOrDislikeButton: String
            var cartButton: String
            guard let collectionNFTCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CatalogNFTCell.identifier,
                for: indexPath) as? CatalogNFTCell else { return UICollectionViewCell() }
            let nftId = viewModel.collection.nfts[indexPath.row]

            if let imageURLString = viewModel.nfts(by: nftId)?.images.first,
               let imageURL = URL(string: imageURLString.encodeUrl),
               let price = viewModel.nfts(by: nftId)?.price.asETHCurrency,
               let rating = viewModel.nfts(by: nftId)?.rating {
                let isNFTLiked = viewModel.isNFTLiked(with: nftId)
                let isNFTinOrder = viewModel.isNFTInOrder(with: nftId)
                likeOrDislikeButton = isNFTLiked ? "Like" : "dislike"
                cartButton = isNFTinOrder ? "inCart" : "cart"
                collectionNFTCell.configure(
                    nftImage: imageURL,
                    likeOrDislikeImage: likeOrDislikeButton,
                    rating: rating,
                    title: viewModel.nfts(by: nftId)?.name ?? "",
                    price: price,
                    cartImage: cartButton,
                    likeOrDislikeButtonAction: { [weak self] in
                        self?.likeOrDislikeButtonTapped(idNFT: nftId)
                    },
                    cartButtonAction: { [weak self] in
                        self?.cartButtonTapped(idNFT: nftId)
                    })
            }
            return collectionNFTCell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .image:
            return 1
        case .description:
            return 1
        case .collection:
            return viewModel.collection.nfts.count
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NFTCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let section = Section(rawValue: indexPath.section) else { return .zero }
        switch section {
        case .image:
            return CGSize(width: self.collectionView.bounds.width, height: 310)
        case .description:
            return CGSize(width: self.collectionView.bounds.width, height: 160)
        case .collection:
            let bounds = UIScreen.main.bounds
            let width = (bounds.width - 50) / 3
            return CGSize(width: width, height: 200)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let section = Section(rawValue: section) else { return .zero }
        switch section {
        case .image:
            return .zero
        case .description:
            return .zero
        case .collection:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}

// MARK: - Extension

extension NFTCollectionView {
    enum Section: Int, CaseIterable {
        case image
        case description
        case collection
    }
}
