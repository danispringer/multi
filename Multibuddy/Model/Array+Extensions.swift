//
//  Array+Extensions.swift
//  Multibuddy
//
//  Created by Daniel Springer on 7/22/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import Foundation

protocol HasMiddleValue {

    associatedtype ItemType
    func middle() -> [ItemType]

}

extension Array: HasMiddleValue {

    typealias ItemType = Iterator.Element

    func middle() -> [ItemType] {
        guard count > 0 else {
            return [ItemType]()
        }

        let middleIndex = count / 2
        let middleArray: [ItemType]

        if count % 2 != 0 {
            middleArray = [self[middleIndex]]
        } else {
            middleArray = [self[middleIndex - 1], self[middleIndex]]
        }

        return middleArray
    }

}
