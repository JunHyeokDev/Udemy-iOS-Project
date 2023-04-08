//
//  ViewController.swift
//  Password
//
//  Created by 김준혁 on 2023/04/08.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Properties
    
    let passwordTextField = PasswordTextField(placeHolderText: "New Password")
    let stackView = UIStackView()
    let criteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

}


extension ViewController {
    func setup() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        criteriaView.translatesAutoresizingMaskIntoConstraints = false

    }
    func layout() {
        //stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(criteriaView)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
        ])
    }
    
}

