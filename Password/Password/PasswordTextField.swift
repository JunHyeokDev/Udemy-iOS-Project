//
//  PasswordTextField.swift
//  Password
//
//  Created by 김준혁 on 2023/04/08.
//

import UIKit

protocol PasswordTextFieldDelegate : AnyObject {
    func editingChanged(_ sender: PasswordTextField)
    func editingDidEnd(_ sender: PasswordTextField)
}


class PasswordTextField: UIView {
    //MARK: - Typealias
    /**
        A function one passes in to do custom validation on the text field.
     - Parameter : textValue: The value of text to validate
     - Returns : A Bool indicating whether text is valid, and if not a String containing an error message
     */
    typealias CustomValidation = (_ textValue: String?) -> (Bool, String)?
    
    //MARK: - Properties
    let lockImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
    let textField = UITextField()
    let eyeButton = UIButton(type: .custom)
    let errorLable = UILabel()
    
    let divider = UIView()
    
    let placeHolderText: String
    var customValidation : CustomValidation?
    
    weak var delegate : PasswordTextFieldDelegate?
    
    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    init(placeHolderText: String) {
        self.placeHolderText = placeHolderText
        super.init(frame: .zero) // we need to specify all the properties before we call the super.init
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 60)
    }
}

extension PasswordTextField {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        lockImageView.translatesAutoresizingMaskIntoConstraints = false

        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.placeholder = placeHolderText
        textField.delegate = self
        textField.keyboardType = .asciiCapable // NO EMOJI HERE!
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText,       attributes : [NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel])
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.setImage(UIImage(systemName: "eye.circle"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye.slash.circle"), for: .selected)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .separator
        
        
        errorLable.translatesAutoresizingMaskIntoConstraints = false
        errorLable.textColor = .systemRed
        errorLable.font = .preferredFont(forTextStyle: .footnote)
        errorLable.text = "Your password must meet the requirements below" // Truncates means Three dots ... and it's not showing all of they got
        
//        errorLable.adjustsFontSizeToFitWidth = true
//        errorLable.minimumScaleFactor = 0.8
        
        errorLable.numberOfLines = 0
        errorLable.lineBreakMode = .byWordWrapping
        errorLable.isHidden = true
    }
    
    func layout() {
        
        addSubview(lockImageView)
        addSubview(textField)
        addSubview(eyeButton)
        addSubview(divider)
        addSubview(errorLable)
        
        
        NSLayoutConstraint.activate([
            lockImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lockImageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: lockImageView.trailingAnchor, multiplier: 1),
            textField.topAnchor.constraint(equalTo: topAnchor),
            
            eyeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            eyeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: textField.trailingAnchor, multiplier: 1),
            eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 0),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.topAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),
        
            errorLable.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 4),
            errorLable.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLable.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // CHCR
        // defaultHigh : I want you to Hug urself highly and tiglhy, so U can't be widen urself!
        // defaultLow  : I want you to stretch urself. so U can go wide
        lockImageView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        textField.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        eyeButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
    }
}



//MARK: - Actions
extension PasswordTextField {
    @objc
    func togglePasswordView(_ sender: Any) {
        textField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }
    @objc func textFieldEditingChanged(_ sender : UITextField) {
        delegate?.editingChanged(self)
    }
    // Then, How we can talk back to our View Controller?
    
}



// MARK: - Delegate
extension PasswordTextField : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("DEBUG : textFIeldDidEndEditing : \(textField.text ?? "") ")
        delegate?.editingDidEnd(self)
    }
    
    // Called when 'return' key pressed. NEcessary for dismissing keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("DEBUG : textFieldShouldReturn")
        textField.endEditing(true) // resign first responder
        return true
    }
}



// MARK: - Validation
extension PasswordTextField {
    
    func validate() -> Bool {
        if let customValidation = customValidation,
           let customValidationResult = customValidation(text),
           customValidationResult.0 == false {
            showError(customValidationResult.1)
            return false
        }
        clearError()
        return true
    }
    
    private func showError(_ errorMessage: String) {
        errorLable.isHidden = false
        errorLable.text = errorMessage
    }
    
    private func clearError() {
        errorLable.isHidden = true
        errorLable.text = ""
    }
    
}
