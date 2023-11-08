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

        tabBar.backgroundColor = .ypWhite
        tabBar.barTintColor = .ypWhite
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypBlack

        tabBar.isTranslucent = false

        // Профиль
        let profileViewModel = ProfileViewModel()
        let profileVC = ProfileViewController(profileViewModel: profileViewModel)

        let profileViewController = UINavigationController(
            rootViewController: profileVC
        )

        profileViewController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle.fill"),
            selectedImage: nil)

        // Каталог
        let catalogViewController = UINavigationController(
            rootViewController: CatalogViewController(viewModel: CatalogViewModel()))
        catalogViewController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(named: "catalogTabBarImageNoActive"),
            selectedImage: UIImage(named: "catalogTabBarImageActive"))

        // Корзина
       let cartModel: ShoppingCartContentLoader = ShoppingCartContentLoader(networkClient: DefaultNetworkClient())
        let cartViewModel: ShoppingCartViewModel = ShoppingCartViewModel(model: cartModel)
        
        let cartVC = UINavigationController(rootViewController: ShoppingCartViewController(viewModel: cartViewModel))
       
        cartVC.tabBarItem = UITabBarItem(
            title: "Корзина",
            image: UIImage(named: "cartTabBarImageNoActive"),
            selectedImage: UIImage(named: "cartTabBarImageActive"))
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
            cartVC,
            statisticsViewController,
        ]
    }
}
