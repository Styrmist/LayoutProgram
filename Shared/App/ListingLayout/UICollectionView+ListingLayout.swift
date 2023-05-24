//
//  UICollectionView+ListingLayout.swift
//  LayoutProgram
//
//  Created by Kirill Danilov on 24.04.2023.
//

import UIKit

extension UICollectionView {
    
    func reloadDataAndListingLayout() {
        if let listingLayout = self.collectionViewLayout as? ListingLayout {
            listingLayout.resetLayoutCache()
        }
        self.reloadData()
    }
    
}
