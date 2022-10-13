//
//  ExtensionPasswordViewController.swift
//  iOS7-HW17-Kholodkov Denis
//
//  Created by Денис Холодков on 13.10.2022.
//

import UIKit

extension PasswordViewController {

   func makeButton(title: String, action: Selector, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 16
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
