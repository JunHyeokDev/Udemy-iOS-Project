//
//  ViewController.swift
//  Password
//
//  Created by 김준혁 on 2023/04/08.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Properties
    
    let stackView = UIStackView()
    let passwordTextField = PasswordTextField(placeHolderText: "New Password")
    let criteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    let statusView = PasswordStatusView()
    
    let confirmPasswordTextField = PasswordTextField(placeHolderText: "Re-enter new password")
    
    let resetButton = UIButton(type: .system)
    
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
        passwordTextField.delegate = self
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.layer.cornerRadius = 9
        statusView.clipsToBounds = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.configuration = .filled()
        resetButton.setTitle("Reset password", for: [])
        //resetButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .primaryActionTriggered)
    }
    func layout() {
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(statusView)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(resetButton)
        
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
        ])
    }
    
}


// MARK: - Delegate

extension ViewController : PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordTextField) {
        if sender == passwordTextField {
            statusView.updateDisplay(sender.textField.text ?? "")
        }
    }
}
