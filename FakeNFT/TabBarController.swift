//
//  TabBarController.swift
//  FakeNFT
//
//  Created by Артем Кохан on 06.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.backgroundColor = .background
        tabBar.barTintColor = .background
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypLightGrey
        tabBar.isTranslucent = false

        // Профиль
        let profileViewController = ProfileViewController()

        let profileViewModel = ProfileViewModel()
        profileViewController.profileViewModel = profileViewModel

        profileViewController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "circle.fill"),
            selectedImage: nil
        )

        // Каталог
        let catalogViewController = UINavigationController(
            rootViewController: CatalogViewController(viewModel: CatalogViewModel()))
        catalogViewController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(named: "catalogTabBarImageNoActive"),
            selectedImage: UIImage(named: "catalogTabBarImageActive"))

        // Корзина
        let shoppingCartViewController = ShoppingCartViewController()

        let shoppingCartViewModel = ShoppingCartViewModel()
        shoppingCartViewController.shoppingCartViewModel = shoppingCartViewModel

        shoppingCartViewController.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(systemName: "trash"),
            selectedImage: nil
        )

        // Статистика
        let statisticsViewController = StatisticsViewController()

        let statisticsViewModel = StatisticsViewModel()
        statisticsViewController.statisticsViewModel = statisticsViewModel

        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "flag.2.crossed.fill"),
            selectedImage: nil
        )

        self.viewControllers = [
            profileViewController,
            catalogViewController,
            shoppingCartViewController,
            statisticsViewController
        ]
    }
}
