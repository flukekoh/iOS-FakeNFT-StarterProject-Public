import UIKit
import WebKit

final class WebViewView: UIViewController {

    // MARK: - Properties

    var url: URL?

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        addSubviews()
        setupLayout()
        makeNavBar()
        loadWebView()
    }

    // MARK: - Private Func

    private func loadWebView() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func addSubviews() {
        view.addSubview(webView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
        }
    }

    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
