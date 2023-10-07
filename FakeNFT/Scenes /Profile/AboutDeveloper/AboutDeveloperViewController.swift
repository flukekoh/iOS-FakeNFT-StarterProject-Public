//
//  AboutDeveloperViewController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 07.10.2023.
//

import UIKit
import WebKit

class AboutDeveloperViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Создайте экземпляр WKWebView
        webView = WKWebView()

        // Назначьте делегата навигации
        webView.navigationDelegate = self

        // Добавьте webView как подпредставление в ваш контроллер
        view.addSubview(webView)

        // Задайте фрейм для webView
        webView.frame = view.frame

        // Загрузите URL в webView
        if let url = URL(string: "https://www.speedhunters.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}







