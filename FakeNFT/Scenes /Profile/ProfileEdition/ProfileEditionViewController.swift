//
//  ProfileEditionViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 06.10.2023.
//

import UIKit

class TextField: UITextField {
    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

final class ProfileEditionViewController: UIViewController {
    
    private lazy var closeProfileButton: UIButton = {
        let closeProfileButton = UIButton.systemButton(
            with: UIImage(named: "editProfile")!,
            target: self, action: #selector(didTapCloseProfileButton))
        closeProfileButton.tintColor = .black
        closeProfileButton.translatesAutoresizingMaskIntoConstraints = false
        
        return closeProfileButton
    }()
    
    private let profilePictureImage: UIImageView = {
        let profilePictureImage = UIImageView()
        profilePictureImage.translatesAutoresizingMaskIntoConstraints = false
        profilePictureImage.image = UIImage(named: "MockUserPic")
        
        return profilePictureImage
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Имя"
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return nameLabel
    }()
    
    private lazy var nameTextField: UITextField = {
        let nameTextField = TextField()
        
        nameTextField.placeholder = "Введите название трекера"
//        nameTextField.delegate = self
        nameTextField.layer.cornerRadius = 16
        nameTextField.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Описание"
        descriptionLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionLabel
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let descriptionTextField = TextField()
        
        descriptionTextField.placeholder = "Введите название трекера"
//        descriptionTextField.delegate = self
        descriptionTextField.layer.cornerRadius = 16
        descriptionTextField.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        return descriptionTextField
    }()
    
    private let websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.text = "Сайт"
        websiteLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return websiteLabel
    }()
    
    private lazy var websiteTextField: UITextField = {
        let websiteTextField = TextField()
        
        websiteTextField.placeholder = "Введите название трекера"
//        websiteTextField.delegate = self
        websiteTextField.layer.cornerRadius = 16
        websiteTextField.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        
        websiteTextField.translatesAutoresizingMaskIntoConstraints = false
        return websiteTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "ypWhite")
    }
    
    private func setupHierarchy() {
        view.addSubview(closeProfileButton)
        view.addSubview(profilePictureImage)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(websiteLabel)
        view.addSubview(websiteTextField)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            closeProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeProfileButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            closeProfileButton.heightAnchor.constraint(equalToConstant: 42),
            closeProfileButton.widthAnchor.constraint(equalToConstant: 42),
            
            profilePictureImage.topAnchor.constraint(equalTo: closeProfileButton.bottomAnchor, constant: 22),
            profilePictureImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePictureImage.heightAnchor.constraint(equalToConstant: 70),
            profilePictureImage.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: profilePictureImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
//            nameLabel.centerYAnchor.constraint(equalTo: profilePictureImage.centerYAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 22),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 132),
            
            websiteLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),
            websiteLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            websiteLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            websiteLabel.heightAnchor.constraint(equalToConstant: 22),
            
            websiteTextField.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor, constant: 8),
            websiteTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            websiteTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            websiteTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    private func didTapCloseProfileButton() {
        
    }
}
