//
//  UICollectionView+register.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 29.04.2023.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) where T: Reusable {
        self.register(cellClass, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_ viewClass: T.Type, ofKind kind: String) where T: Reusable {
        self.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
}
