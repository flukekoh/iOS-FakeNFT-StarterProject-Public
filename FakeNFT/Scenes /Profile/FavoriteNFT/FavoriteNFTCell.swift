//
//  FavoriteNFTCell.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit

final class FavoriteNFTCell: UICollectionViewCell {
    static let identifier = "FavoriteNFTCell"
    
    private var nftImage: UIImageView = {
        let nftImage = UIImageView()
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.image = UIImage(named: "MockUserPic")
        
        return nftImage
    }()
    
    private let onLikeImage: UIImageView = {
        let onLikeImage = UIImageView()
        onLikeImage.translatesAutoresizingMaskIntoConstraints = false
        onLikeImage.image = UIImage(named: "dislike")
        
        return onLikeImage
    }()
    
    private let offLikeImage: UIImageView = {
        let offLikeImage = UIImageView()
        offLikeImage.translatesAutoresizingMaskIntoConstraints = false
        offLikeImage.image = UIImage(named: "Like")
        
        return offLikeImage
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let ratingImage: UIImageView = {
        let ratingImage = UIImageView()
        ratingImage.translatesAutoresizingMaskIntoConstraints = false
        ratingImage.image = UIImage(named: "star_yellow")
        
        return ratingImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    func setupHierarchy() {
        //        selectionStyle = .none
        contentView.addSubview(nftImage)
        contentView.addSubview(onLikeImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingImage)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.heightAnchor.constraint(equalToConstant: 80),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            
            onLikeImage.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: -6),
            onLikeImage.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: -6),
            onLikeImage.heightAnchor.constraint(equalToConstant: 40),
            onLikeImage.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 7),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            //            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ratingImage.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            ratingImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            //            ratingImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingImage.heightAnchor.constraint(equalToConstant: 12),
            
            priceLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            priceLabel.topAnchor.constraint(equalTo: ratingImage.bottomAnchor, constant: 8),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            //            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
        ])
    }
    func configure(nft: NFTModel) {
        nftImage.image = nft.nftImage
        if nft.markedFavorite {
            onLikeImage.image = onLikeImage.image
        } else {
            onLikeImage.image = offLikeImage.image
        }
        
        titleLabel.text = nft.title
        priceLabel.text = "\(nft.price)"
        
    }
}

