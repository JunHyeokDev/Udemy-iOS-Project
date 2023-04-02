//
//  UIVivewController+Utils.swift
//  Bankey
//
//  Created by 김준혁 on 2023/03/31.
//

import UIKit

extension UIViewController {
        // Old Version!
//    func setStatusBar() {
//        let statusBarSize = UIApplication.shared.statusBarFrame.size
//        let frame = CGRect(origin: .zero, size: statusBarSize)
//        let statusbarView = UIView(frame: frame)
//
//        statusbarView.backgroundColor = appColor
//        view.addSubview(statusbarView)
//    }
    
    func setStatusBar() {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground() // to hide Navigation Bar Line also
            navBarAppearance.backgroundColor = appColor
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
    
    func setTabBarImage(imageName : String, title : String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName , withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
}
