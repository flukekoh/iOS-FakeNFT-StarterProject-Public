//
//  AboutDeveloperViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit
import WebKit

final class AboutDeveloperViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView?
    private var profileLink: String?

    init(webView: WKWebView?, profileLink: String?) {
        self.webView = webView
        self.profileLink = profileLink
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView()
        webView?.navigationDelegate = self

        view.addSubview(webView ?? UIView())
        webView?.frame = view.frame

        guard let profileLink = profileLink,
              let url = URL(string: profileLink) else { return }
        let request = URLRequest(url: url)

        webView?.load(request)
    }
}
