//
//  File.swift
//  Bankey
//
//  Created by 김준혁 on 2023/03/30.
//

import Foundation

import UIKit
 
class NewView: UIView {
 
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
 
extension NewView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
    }
 
    func layout() {
 
    }
}
