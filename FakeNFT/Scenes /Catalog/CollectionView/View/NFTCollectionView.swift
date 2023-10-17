import UIKit

final class NFTCollectionView: UIViewController {
    
    private let viewModel: CollectionViewModel
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
