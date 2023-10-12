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
        let prefs = WKWebpagePreferences()
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configuration)
//        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .black// UIColor(named: "ypWhite")
        return webView
    }()

    private var profileLink: String?

    init(webView: WKWebView?, profileLink: String?) {
        self.webView = webView ?? WKWebView()
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
        view.backgroundColor = UIColor(named: "ypWhite")
        webView.navigationDelegate = self
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
}
