import UIKit
import Kingfisher

final class CatalogTableViewCell: UITableViewCell {
    static let identifier = "CatalogTableViewCell"
    
    private lazy var imageCategory: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.font = .bodyBold
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: CatalogTableViewCell.identifier)
        
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        self.contentView.addSubview(imageCategory)
        self.contentView.addSubview(label)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageCategory.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageCategory.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCategory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageCategory.heightAnchor.constraint(equalToConstant: 140),
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: imageCategory.bottomAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -21)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: URL, title: String) {
        imageCategory.kf.setImage(with: image)
        label.text = title
    }
}
