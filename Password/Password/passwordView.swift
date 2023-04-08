//
//  passwordView.swift
//  Password
//
//  Created by 김준혁 on 2023/04/08.
//

import UIKit

class passwordView: UIView {
    
    let lockImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: 200, height: 200)
//    }
}

extension passwordView {
    func style() {
        addSubview(lockImage)
        
        translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "lock.fill")
        lockImage.translatesAutoresizingMaskIntoConstraints = false
        lockImage.image = image
        
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            lockImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            lockImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            lockImage.heightAnchor.constraint(equalToConstant: 24),
            lockImage.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
}
