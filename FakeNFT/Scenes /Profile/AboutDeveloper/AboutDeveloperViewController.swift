//
//  AboutDeveloperViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit
import WebKit

final class AboutDeveloperViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .ypWhite
        return webView
    }()

    private lazy var customBackButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "BackButton"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        uiBarButtonItem.tintColor = .ypBlack
        return uiBarButtonItem
    }()

    private var profileLink: String?

    init(profileLink: String?) {
        self.profileLink = profileLink
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupHierarchy()
        setupLayout()

        guard let profileLink = profileLink,
              let url = URL(string: profileLink) else { return }
        let request = URLRequest(url: url)

        webView.load(request)
    }

    private func setupView() {
        view.backgroundColor = .ypWhite
        webView.navigationDelegate = self

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = customBackButton
    }

    private func setupHierarchy() {
        view.addSubview(webView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
