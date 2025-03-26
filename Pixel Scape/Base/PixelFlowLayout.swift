//
//  PixelFlowLayout.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 19/03/2025.
//

import UIKit

class PixelFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        self.itemSize = updateLayout(for: 200) // Default height, will be overridden

    }
    
    func updateLayout(for height: CGFloat) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 10
        let totalSpacing = spacing * (numberOfColumns - 1)
        let itemWidth = (collectionView!.bounds.width - totalSpacing) / numberOfColumns
        self.minimumInteritemSpacing = spacing
        self.minimumLineSpacing = spacing
        return CGSize(width: itemWidth, height: height)
    }
    
}
