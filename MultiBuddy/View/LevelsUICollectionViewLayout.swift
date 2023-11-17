//
//  LevelsUICollectionViewLayout.swift
//  MultiBuddy
//
//  Created by dani on 11/17/23.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

class LevelsUICollectionViewLayout: UICollectionViewLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 5

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }

}
