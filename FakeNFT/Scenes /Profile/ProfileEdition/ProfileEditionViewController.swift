//
//  ProfileEditionViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 06.10.2023.
//

import UIKit
import Kingfisher

final class ProfileEditionViewController: UIViewController {
    private let viewModel: ProfileViewModel

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.bounds.width, height: 1000)
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var closeProfileButton: UIButton = {
        let closeProfileButton = UIButton.systemButton(
            with: UIImage(named: "closeProfile") ?? UIImage(),
            target: self,
            action: #selector(didTapCloseProfileButton))
        closeProfileButton.tintColor = .black
        closeProfileButton.translatesAutoresizingMaskIntoConstraints = false

        return closeProfileButton
    }()

    private let profilePictureImage: UIImageView = {
        let profilePictureImage = UIImageView()
        profilePictureImage.layer.cornerRadius = 35
        profilePictureImage.layer.masksToBounds = true
        profilePictureImage.translatesAutoresizingMaskIntoConstraints = false
        profilePictureImage.image = UIImage(named: "MockUserPic")

        return profilePictureImage
    }()

    private let changePictureLabel: UILabel = {
        let changePictureLabel = UILabel()
        changePictureLabel.text = "Сменить фото"
        changePictureLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        changePictureLabel.textColor = .white
        changePictureLabel.backgroundColor = .black.withAlphaComponent(0.5)
        changePictureLabel.layer.cornerRadius = 35
        changePictureLabel.layer.masksToBounds = true
        changePictureLabel.translatesAutoresizingMaskIntoConstraints = false
        changePictureLabel.numberOfLines = 2
        changePictureLabel.textAlignment = .center

        return changePictureLabel
    }()

    private let profileImageLinkLabel: UILabel = {
        let profileImageLinkLabel = UILabel()
        profileImageLinkLabel.text = "Загрузить изображение"
        profileImageLinkLabel.font = .bodyRegular
        profileImageLinkLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageLinkLabel.isHidden = true

        return profileImageLinkLabel
    }()

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Имя"
        nameLabel.font = .headline3
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        return nameLabel
    }()

    private lazy var nameTextField: UITextField = {
        let nameTextField = TextField()
        nameTextField.placeholder = "Введите имя"
        nameTextField.delegate = self
        nameTextField.layer.cornerRadius = 16
        nameTextField.backgroundColor = .textFiledBackground
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.tintColor = UIColor(named: "iconBlue")

        return nameTextField
    }()

    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Описание"
        descriptionLabel.font = .headline3
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        return descriptionLabel
    }()

    private lazy var descriptionTextField: UITextField = {
        let descriptionTextField = TextField()
        descriptionTextField.placeholder = "Введите описание"
        descriptionTextField.delegate = self
        descriptionTextField.layer.cornerRadius = 16
        descriptionTextField.backgroundColor = .textFiledBackground
        descriptionTextField.clearButtonMode = .whileEditing
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.tintColor = UIColor(named: "iconBlue")

        return descriptionTextField
    }()

    private let websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.text = "Сайт"
        websiteLabel.font = .headline3
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false

        return websiteLabel
    }()

    private lazy var websiteTextField: UITextField = {
        let websiteTextField = TextField()
        websiteTextField.placeholder = "Укажите ссылку"
        websiteTextField.delegate = self
        websiteTextField.layer.cornerRadius = 16
        websiteTextField.backgroundColor = .textFiledBackground
        websiteTextField.clearButtonMode = .whileEditing
        websiteTextField.translatesAutoresizingMaskIntoConstraints = false
        websiteTextField.tintColor = UIColor(named: "iconBlue")

        return websiteTextField
    }()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        setupView()
        setupHierarchy()
        setupLayout()
    }

    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changePictureDidTap))

        changePictureLabel.addGestureRecognizer(tapGesture)
        changePictureLabel.isUserInteractionEnabled = true

        view.backgroundColor = UIColor(named: "ypWhite")
        self.navigationController?.navigationBar.isHidden = true
        guard let currentProfile = viewModel.profile else { return }

        profilePictureImage.kf.setImage(
            with: URL(string: currentProfile.avatar),
            placeholder: UIImage(named: "MockUserPic"),
            options: [.processor(RoundCornerImageProcessor(cornerRadius: 35))])

        nameTextField.text = currentProfile.name
        descriptionTextField.text = currentProfile.description
        websiteTextField.text = currentProfile.website
        profileImageLinkLabel.text = currentProfile.avatar
    }

    private func setupHierarchy() {
        scrollView.addSubview(closeProfileButton)
        scrollView.addSubview(profilePictureImage)
        scrollView.addSubview(changePictureLabel)
        scrollView.addSubview(profileImageLinkLabel)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(descriptionTextField)
        scrollView.addSubview(websiteLabel)
        scrollView.addSubview(websiteTextField)

        view.addSubview(scrollView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            closeProfileButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            closeProfileButton.trailingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.defaultOffset),
            closeProfileButton.heightAnchor.constraint(equalToConstant: 42),
            closeProfileButton.widthAnchor.constraint(equalToConstant: 42),

            profilePictureImage.topAnchor.constraint(equalTo: closeProfileButton.bottomAnchor, constant: 22),
            profilePictureImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profilePictureImage.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            profilePictureImage.widthAnchor.constraint(equalToConstant: Constants.imageSize),

            changePictureLabel.centerXAnchor.constraint(equalTo: profilePictureImage.centerXAnchor),
            changePictureLabel.centerYAnchor.constraint(equalTo: profilePictureImage.centerYAnchor),
            changePictureLabel.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            changePictureLabel.heightAnchor.constraint(equalToConstant: Constants.imageSize),

            profileImageLinkLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileImageLinkLabel.topAnchor.constraint(equalTo: changePictureLabel.bottomAnchor, constant: 12),

            nameLabel.topAnchor.constraint(equalTo: profilePictureImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.defaultOffset),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),

            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.defaultOffset),
            nameTextField.trailingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.defaultOffset),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.defaultOffset),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 22),

            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.defaultOffset),
            descriptionTextField.trailingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.defaultOffset),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 132),

            websiteLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.defaultOffset),
            websiteLabel.heightAnchor.constraint(equalToConstant: 22),

            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.defaultOffset),
            websiteTextField.trailingAnchor.constraint(
                equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.defaultOffset),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc
    private func didTapCloseProfileButton() {
        viewModel.putProfile(
            name: nameTextField.text ?? "",
            avatar: profileImageLinkLabel.text ?? "",
            description: descriptionTextField.text ?? "",
            website: websiteTextField.text ?? "",
            likes: viewModel.profile?.likes ?? [""])
        dismiss(animated: true)
    }

    @objc
    private func changePictureDidTap() {
        profileImageLinkLabel.text = viewModel.profile?.avatar
        profileImageLinkLabel.isHidden = false

        let alertController = UIAlertController(
            title: "Введите ссылку на изображение",
            message: nil,
            preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Ссылка на изображение"
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first,
               let imageURLString = textField.text,
               let imageURL = URL(string: imageURLString),
               UIApplication.shared.canOpenURL(imageURL) {
                self?.profileImageLinkLabel.text = imageURLString

                self?.profilePictureImage.kf.setImage(
                    with: URL(string: imageURLString),
                    placeholder: UIImage(named: "MockUserPic"),
                    options: [.processor(RoundCornerImageProcessor(cornerRadius: 35))])
            } else {
                self?.showInvalidURLAlert()
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    func showInvalidURLAlert() {
        let alertController = UIAlertController(
            title: "Неверный формат ссылки",
            message: "Пожалуйста, введите правильную ссылку на изображение.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
}

extension ProfileEditionViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileEditionViewController {
    private enum Constants {
        static let defaultOffset: CGFloat = 16
        static let imageSize: CGFloat = 70
    }
}
