//
//  tempImage.swift
//  Password
//
//  Created by 김준혁 on 2023/04/08.
//

import UIKit

class tempImage: UIView {
    
    let lockImage =  UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lockImage)
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

extension tempImage {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        
        lockImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "lock.fill")
        lockImage.image = image
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            lockImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            lockImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
