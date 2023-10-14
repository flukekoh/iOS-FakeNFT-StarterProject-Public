//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 05.10.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class ProfileViewController: UIViewController {
    private var profileViewModel: ProfileViewModel

    private lazy var editProfileButton = UIBarButtonItem(
        image: UIImage(named: "editProfile") ?? UIImage(),
        style: .plain,
        target: self,
        action: #selector(didTapEditProfileButton)
    )

    private let profilePictureImage: UIImageView = {
        let profilePictureImage = UIImageView()
        profilePictureImage.layer.cornerRadius = 35
        profilePictureImage.layer.masksToBounds = true
        profilePictureImage.translatesAutoresizingMaskIntoConstraints = false
        profilePictureImage.image = UIImage()

        return profilePictureImage
    }()

    private let profileNameLabel: UILabel = {
        let profileNameLabel = UILabel()
        profileNameLabel.text = ""
        profileNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false

        return profileNameLabel
    }()

    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = ""
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        return descriptionLabel
    }()

    private let profileLinkLabel: UILabel = {
        let profileLinkLabel = UILabel()
        profileLinkLabel.text = ""
        profileLinkLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        profileLinkLabel.translatesAutoresizingMaskIntoConstraints = false

        profileLinkLabel.font = UIFont.systemFont(ofSize: 15)
        profileLinkLabel.textColor = UIColor(named: "iconBlue")
        return profileLinkLabel
    }()

    private var tableData: [String]? {
        return ["Мои NFT", "Избранные NFT", "О Разработчике"]
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.backgroundColor = .tableViewBackground
        tableView.layer.cornerRadius = 16

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let tableCellHeight: CGFloat = 54

    init(profileViewModel: ProfileViewModel) {
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

        profileViewModel.onProfileLoad = { [weak self] profile in
            guard let self else { return }

            self.setupProfileContent(profile: profile)
            ProgressHUD.dismiss()
        }

        profileViewModel.onError = { [weak self] error in
            guard let self else { return }
            self.showAlert(title: "Ошибка", message: error.localizedDescription)

            ProgressHUD.dismiss()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileViewModel.viewWillAppear()
    }

    private func setupProfileContent(profile: ProfileModel) {
        profilePictureImage.kf.setImage(
            with: URL(string: profile.avatar),
            placeholder: UIImage(named: "MockUserPic"),
            options: [.processor(RoundCornerImageProcessor(cornerRadius: 35))])
        profileNameLabel.text = profile.name
        descriptionLabel.text = profile.description
        profileLinkLabel.text = profile.website

        var profileCell = tableView.cellForRow(at: [0, 0]) as? ProfileCell
        profileCell?.configure(label: "Мои NFT (\(profile.nfts.count))")

        profileCell = tableView.cellForRow(at: [0, 1]) as? ProfileCell
        profileCell?.configure(label: "Избранные NFT (\(profile.likes.count))")
    }

    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileLinkDidTap))

        profileLinkLabel.addGestureRecognizer(tapGesture)
        profileLinkLabel.isUserInteractionEnabled = true

        view.backgroundColor = UIColor(named: "ypWhite")

        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = editProfileButton
        self.navigationController?.navigationBar.isHidden = false
    }

    private func setupHierarchy() {
        view.addSubview(profilePictureImage)
        view.addSubview(profileNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(profileLinkLabel)
        view.addSubview(tableView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            profilePictureImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profilePictureImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profilePictureImage.heightAnchor.constraint(equalToConstant: 70),
            profilePictureImage.widthAnchor.constraint(equalToConstant: 70),

            profileNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileNameLabel.leadingAnchor.constraint(equalTo: profilePictureImage.trailingAnchor, constant: 16),
            profileNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profileNameLabel.centerYAnchor.constraint(equalTo: profilePictureImage.centerYAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: profilePictureImage.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),

            profileLinkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            profileLinkLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileLinkLabel.heightAnchor.constraint(equalToConstant: 28),

            tableView.topAnchor.constraint(equalTo: profileLinkLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(integerLiteral: (tableData?.count ?? 0) * 54))
        ])
    }

    @objc
    private func didTapEditProfileButton() {
        let profileEditionViewController = ProfileEditionViewController(viewModel: profileViewModel)
        let navigationController = UINavigationController(rootViewController: profileEditionViewController)

        present(navigationController, animated: true)
    }

    @objc
    private func profileLinkDidTap() {
        self.present(AboutDeveloperViewController(profileLink: profileLinkLabel.text), animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: // Мои NFT
            let myNFTViewController = MyNFTViewController()
            navigationController?.pushViewController(myNFTViewController, animated: true)
        case 1: // Избранные NFT
            let favoriteNFTViewController = FavoriteNFTViewController()
            navigationController?.pushViewController(favoriteNFTViewController, animated: true)
        case 2: // О Разработчике
            let aboutDeveloperViewController = AboutDeveloperViewController(
                profileLink: profileLinkLabel.text)
            navigationController?.pushViewController(aboutDeveloperViewController, animated: true)
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableCellHeight
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier) as? ProfileCell
        else { return UITableViewCell() }

        profileCell.configure(label: tableData?[indexPath.row] ?? "")
        return profileCell
    }
}
