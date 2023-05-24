//
//  UICollectionView+Dequeue.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 28.04.2023.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell & Reusable>(forItemAt indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView & Reusable>(ofKind kind: String, for indexPath: IndexPath) -> T {
        self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
}
