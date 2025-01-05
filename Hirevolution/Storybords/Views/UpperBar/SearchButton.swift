//
//  SearchButton.swift
//  Project-G5
//
//  Created by Mac 14 on 12/11/2024.
//

import UIKit

class SearchButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let tabBarController = window.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}
