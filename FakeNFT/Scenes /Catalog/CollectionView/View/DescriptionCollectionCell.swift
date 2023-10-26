import UIKit

final class DescriptionCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "DescriptionCollectionCell"
    
    var onTapped: (() -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var collectionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.font = .headline3
        return label
    }()
    
    private lazy var creatorCollectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.font = .caption2
        return label
    }()
    
    private lazy var descriptionCollectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .caption2
        return label
    }()
    
    private lazy var creatorCollectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.ypBlue, for: .normal)
        button.titleLabel?.font = .caption1
        button.titleLabel?.tintColor = .ypBlue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Func
    
    @objc private func buttonTapped() {
        onTapped?()
    }
    
    private func addSubviews() {
        contentView.addSubview(collectionNameLabel)
        contentView.addSubview(creatorCollectionLabel)
        contentView.addSubview(creatorCollectionButton)
        contentView.addSubview(descriptionCollectionLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            collectionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            creatorCollectionLabel.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 13),
            creatorCollectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            creatorCollectionLabel.bottomAnchor.constraint(equalTo: descriptionCollectionLabel.topAnchor, constant: 5),
            
            creatorCollectionButton.topAnchor.constraint(equalTo: collectionNameLabel.bottomAnchor, constant: 12),
            creatorCollectionButton.leadingAnchor.constraint(equalTo: creatorCollectionLabel.trailingAnchor),
            creatorCollectionButton.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -16
            ),
            creatorCollectionButton.bottomAnchor.constraint(equalTo: descriptionCollectionLabel.topAnchor, constant: 4),
            
            descriptionCollectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionCollectionLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            descriptionCollectionLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -24
            )
        ])
    }
    
    func configure(
        title: String,
        subTitle: String,
        description: String,
        buttonTitle: String,
        buttonAction: @escaping () -> Void
    ) {
        collectionNameLabel.text = title
        creatorCollectionLabel.text = subTitle
        creatorCollectionButton.setTitle(buttonTitle, for: .normal)
        descriptionCollectionLabel.text = description
        onTapped = buttonAction
    }
}
