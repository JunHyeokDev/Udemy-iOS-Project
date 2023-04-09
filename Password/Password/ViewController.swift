//
//  ViewController.swift
//  Password
//
//  Created by 김준혁 on 2023/04/08.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - typealias
    typealias CustomValidation = PasswordTextField.CustomValidation
    
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
        style()
        layout()
    }
    
}


extension ViewController {
    func setup() {
        setupNewPassword()
        setupConfirmPassword()
        setupDismisskeyboardGesture()
        setupKeyboardHiding()
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupNewPassword() {
        // ...!! That is the function itself....!!!
        let newPasswordValidation: CustomValidation = { text in
            // Empty text
            guard let text = text, !text.isEmpty else {
                self.statusView.reset()
                return (false, "Enter your password!")
                
            }
            
            // Valid characters
            let validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,@:?!()$\\/#"
            let invalidSet = CharacterSet(charactersIn: validChars).inverted
            guard text.rangeOfCharacter(from: invalidSet) == nil else {
                self.statusView.reset()
                return (false, "Enter valid special chars (.,@:?!()$\\/#) with no spaces")
            }
            
            // Criteria met
            self.statusView.updateDisplay(text) // whatever the user typed
            if !self.statusView.validate(text) {
                return (false, "Your password must meet the requirements below")
            }
            
            return (true,"")
        }
        passwordTextField.customValidation = newPasswordValidation
        passwordTextField.delegate = self
    }
    
    private func setupConfirmPassword() {
        let confirmPasswordValidation: CustomValidation = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your password.")
            }
            
            guard text == self.passwordTextField.text else {
                return (false, "Passwords do not match.")
            }
            
            return (true, "")
        }
        
        confirmPasswordTextField.customValidation = confirmPasswordValidation
        confirmPasswordTextField.delegate = self
        
    }
    
    
    
    private func setupDismisskeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)  ))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc func viewTapped(_ recognizer : UITapGestureRecognizer) {
        view.endEditing(true) // resign first responder
    }
    
    func style() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.layer.cornerRadius = 9
        statusView.clipsToBounds = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.configuration = .filled()
        resetButton.setTitle("Reset password", for: [])
        resetButton.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .primaryActionTriggered)
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
    func editingDidEnd(_ sender: PasswordTextField) {
        print("DEBUG : Delegate!\(sender.textField.text ?? "")")
        // as soon as we lose focus, make X appear!
        statusView.shouldResetCriteria = false
        
        if sender == passwordTextField {
            _ = passwordTextField.validate()
        } else if sender == confirmPasswordTextField {
            _ = confirmPasswordTextField.validate()
        }
    }
    
    func editingChanged(_ sender: PasswordTextField) {
        if sender == passwordTextField {
            statusView.updateDisplay(sender.textField.text ?? "")
        }
    }
}

// MARK: - Keyboard
extension ViewController {
    @objc func keyboardWillShow(sender: NSNotification) {
        // Brute forcing way!
        //view.frame.origin.y = view.frame.origin.y - 200
        
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }
        
        // check if the top of the keyboard is above the  bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        
        // Convert its own coodinate system to the parent's view system. So superview it is!
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        // It's own coordinate system
        //let textFieldBottomY = currentTextField.frame.origin.y + currentTextField.frame.size.height
        
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
        
//        print("DEBUG : convertedTextFieldFrame.origin.y = \(convertedTextFieldFrame.origin.y )")
//        print("DEBUG : convertedTextFieldFrame.size.height = \(convertedTextFieldFrame.size.height)")
//        print("DEBUG : textFieldBottomY = \(textFieldBottomY)")
        
        if textFieldBottomY > keyboardTopY {
//            print("DEBUG : convertedTextFieldFrame.origin.y = \(convertedTextFieldFrame.origin.y )")
//            print("DEBUG : convertedTextFieldFrame.size.height = \(convertedTextFieldFrame.size.height)")
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}


// MARK: Actions
extension ViewController {

    @objc func resetPasswordButtonTapped(sender: UIButton) {
        view.endEditing(true)

        let isValidNewPassword = passwordTextField.validate()
        let isValidConfirmPassword = confirmPasswordTextField.validate()

        if isValidNewPassword && isValidConfirmPassword {
            showAlert(title: "Success", message: "You have successfully changed your password.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        alert.title = title
        alert.message = message
        present(alert, animated: true, completion: nil)
    }
}
