//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit

final class MyNFTCell: UITableViewCell {
    static let identifier = "MyNFTCell"

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

    private var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private let titlePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        selectionStyle = .none
        contentView.addSubview(nftImage)
        contentView.addSubview(onLikeImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(titlePriceLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(ratingImage)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108),

            onLikeImage.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor),
            onLikeImage.topAnchor.constraint(equalTo: nftImage.topAnchor),
            onLikeImage.heightAnchor.constraint(equalToConstant: 40),
            onLikeImage.widthAnchor.constraint(equalToConstant: 40),

            titleLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 23),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            //            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            authorLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            authorLabel.bottomAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: -23),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            //            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titlePriceLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 137),
            titlePriceLabel.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 33),
            titlePriceLabel.heightAnchor.constraint(equalToConstant: 18),
            //            titlePriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 137),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 53),
            priceLabel.heightAnchor.constraint(equalToConstant: 22),
            //            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            ratingImage.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            ratingImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            //            ratingImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingImage.heightAnchor.constraint(equalToConstant: 12)
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
        authorLabel.text = nft.author
        priceLabel.text = "\(nft.price)"
    }
}
