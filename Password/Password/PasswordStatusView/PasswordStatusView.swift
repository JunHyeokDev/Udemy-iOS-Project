//
//  PasswordStatusView.swift
//  Password
//
//  Created by 김준혁 on 2023/04/08.
//

import UIKit

class PasswordStatusView: UIView {
    
    let stackView = UIStackView()
    
    let criteriaLabel = UILabel()
    
    let lengthCriteriaView = PasswordCriteriaView(text: "8-32 characters (no spaces)")
    let uppercaseCriteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    let lowerCaseCriteriaView = PasswordCriteriaView(text: "lowercase (a-z)")
    let digitCriteriaView = PasswordCriteriaView(text: "digit (0-9)")
    let specialCharacterCriteriaView = PasswordCriteriaView(text: "special character (e.g. !@#$%^)")

    
    // Used to determine if we reset citeria back to empty state
    var shouldResetCriteria : Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension PasswordStatusView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        lengthCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        uppercaseCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        lowerCaseCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        digitCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        specialCharacterCriteriaView.translatesAutoresizingMaskIntoConstraints = false
        
        criteriaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 8
//        stackView.backgroundColor = .systemRed
        stackView.distribution = .equalCentering
        
        criteriaLabel.numberOfLines = 0
        criteriaLabel.lineBreakMode = .byWordWrapping
        criteriaLabel.attributedText = makeCriteriaMessage()
        
        
        backgroundColor = .tertiarySystemFill
    }
    
    func layout() {

        stackView.addArrangedSubview(lengthCriteriaView)
        stackView.addArrangedSubview(criteriaLabel)
        stackView.addArrangedSubview(uppercaseCriteriaView)
        stackView.addArrangedSubview(lowerCaseCriteriaView)
        stackView.addArrangedSubview(digitCriteriaView)
        stackView.addArrangedSubview(specialCharacterCriteriaView)
        
        addSubview(stackView)

        // Stack View
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2),
        ])
        
        // MARK: - Dealing with the ambiguity
        // [1] HardCode
//        let height: CGFloat = 20
//        NSLayoutConstraint.activate([
//            lengthCriteriaView.heightAnchor.constraint(equalToConstant: height),
//            uppercaseCriteriaView.heightAnchor.constraint(equalToConstant: height),
//            lowerCaseCriteriaView.heightAnchor.constraint(equalToConstant: height),
//            digitCriteriaView.heightAnchor.constraint(equalToConstant: height),
//            specialCharacterCriteriaView.heightAnchor.constraint(equalToConstant: height),
//        ])
        
//         [2] Change the Parent's Intrinsic content size.
//         return CGSize(width: 200, height: 160)
//         less hard code.
//
//
//         How to deal stack view layout professionally?
//         [3]
//         by deleting the bottom anchor op stack view, contents inside of stackView
//         doesn't feel pressure to fulfill the constaraints. so It can be natural
//
//         [4] Use distriution
//         stackView.distribution

        
    }
    
    private func makeCriteriaMessage() -> NSAttributedString {
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        plainTextAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)

        let attrText = NSMutableAttributedString(string: "Use at least ", attributes: plainTextAttributes)
        attrText.append(NSAttributedString(string: "3 of these 4 ", attributes: boldTextAttributes))
        attrText.append(NSAttributedString(string: "criteria when setting your password:", attributes: plainTextAttributes))

        return attrText
    }
}




//MARK: - Actions
extension PasswordStatusView {
    func updateDisplay(_ text : String) {
        let lengthAndNoSpaceMet = PasswordCriteria.lengthAndNoSpaceMet(text)
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitcaseMet = PasswordCriteria.digitcaseMet(text)
        let specialCharacterMet = PasswordCriteria.specialCharacterMet(text)
        
        if shouldResetCriteria {
            // Inline validation
            lengthAndNoSpaceMet ? lengthCriteriaView.isCriteriaMet = true : lengthCriteriaView.reset()
            uppercaseMet ? uppercaseCriteriaView.isCriteriaMet = true : uppercaseCriteriaView.reset()
            lowercaseMet ? lowerCaseCriteriaView.isCriteriaMet = true : lowerCaseCriteriaView.reset()
            digitcaseMet ? digitCriteriaView.isCriteriaMet = true : digitCriteriaView.reset()
            specialCharacterMet ? specialCharacterCriteriaView.isCriteriaMet = true : specialCharacterCriteriaView.reset()
        } else {
            // Focus lost
            lengthCriteriaView.isCriteriaMet = lengthAndNoSpaceMet
            uppercaseCriteriaView.isCriteriaMet = uppercaseMet
            lowerCaseCriteriaView.isCriteriaMet = lowercaseMet
            digitCriteriaView.isCriteriaMet = digitcaseMet
            specialCharacterCriteriaView.isCriteriaMet = specialCharacterMet
        }
    }
    
    func validate(_ text : String) -> Bool {
        var container : [Bool] = []
        
        let uppercaseMet = PasswordCriteria.uppercaseMet(text)
        let lowercaseMet = PasswordCriteria.lowercaseMet(text)
        let digitcaseMet = PasswordCriteria.digitcaseMet(text)
        let specialCharacterMet = PasswordCriteria.specialCharacterMet(text)
        
        container.append(uppercaseMet)
        container.append(lowercaseMet)
        container.append(digitcaseMet)
        container.append(specialCharacterMet)

        let shouldIGoodToGo = container.filter { $0 == true }.count
        let lengthAndNoSpaceMet = PasswordCriteria.lengthAndNoSpaceMet(text)
        
        if shouldIGoodToGo >= 3 && lengthAndNoSpaceMet { return true }
        
        // Check for 3 of 4 criteria here... ?
        return false
    }
    
    func reset() {
        lengthCriteriaView.reset()
        uppercaseCriteriaView.reset()
        lowerCaseCriteriaView.reset()
        digitCriteriaView.reset()
        specialCharacterCriteriaView.reset()
    }
}
