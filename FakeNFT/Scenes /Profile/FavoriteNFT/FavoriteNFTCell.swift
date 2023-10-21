//
//  FavoriteNFTCell.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit
import Kingfisher

final class FavoriteNFTCell: UICollectionViewCell {
    static let identifier = "FavoriteNFTCell"
    
    var favoriteNFTViewModel: FavoriteNFTViewModel?
    var profileViewModel: ProfileViewModel?
    
    private var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.layer.cornerRadius = 12
        nftImage.layer.masksToBounds = true
        
        return nftImage
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton.systemButton(
            with: UIImage(named: "dislike") ?? UIImage(),
            target: self,
            action: #selector(didTapLikeButton))
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        return likeButton
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .bodyBold
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .caption1
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let numberFormatter = NumberFormatter()
    
    var currentNFT: NFTModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupHierarchy()
        setupLayout()
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ru_RU")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Cannot initiate cell")
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    func setupHierarchy() {
        //        selectionStyle = .none
        
        for _ in 1...5 {
            let imageView = UIImageView(image: UIImage(named: "star"))
            imageView.contentMode = .scaleAspectFit
            
            stackView.addArrangedSubview(imageView)
        }
        
        contentView.addSubview(nftImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stackView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: -6),
            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: -6),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            titleLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 7),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            stackView.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            stackView.heightAnchor.constraint(equalToConstant: 12),
            
            priceLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            priceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            priceLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure() {
        guard let currentNFT = currentNFT else { return }
        nftImage.kf.setImage(with: URL(string: currentNFT.nftImage))
        
        if currentNFT.markedFavorite {
            likeButton.setImage(UIImage(named: "Like"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "dislike"), for: .normal)
        }
        
        titleLabel.text = currentNFT.name
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: currentNFT.price)) {
            priceLabel.text = "\(formattedString) ETH"
        }
        
        for viewNumber in 0...4 {
            if let currentImageView = stackView.arrangedSubviews[viewNumber] as? UIImageView {
                if viewNumber < currentNFT.rating {
                    currentImageView.image = UIImage(named: "star_yellow")
                } else {
                    currentImageView.image = UIImage(named: "star")
                }
            }
        }
    }
    
    @objc
    
    private func didTapLikeButton() {
        guard let currentNFT = currentNFT else { return }
        
        if currentNFT.markedFavorite {
            favoriteNFTViewModel?.likesIds.removeAll { $0 == currentNFT.id }
        } else {
            favoriteNFTViewModel?.likesIds.append(currentNFT.id)
        }
        
        profileViewModel?.putProfile(
            name: nil,
            avatar: nil,
            description: nil,
            website: nil,
            likes: favoriteNFTViewModel?.likesIds
        )
    }
}
