//
//  UIButton+Extensions.swift
//  Multibuddy
//
//  Created by Daniel Springer on 10/24/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

extension UIButton {

    /// - Problem: setting button title using plain string resets font size selected in IB.
    /// - Solution: set attributedString.
    func setTitleNew(_ title: String) {

        let oldFont: UIFont = self.configuration!.attributedTitle!.font ??
        UIFont.preferredFont(forTextStyle: .largeTitle)

        self.configurationUpdateHandler = { button in
            button.configuration!.attributedTitle = AttributedString(
                title, attributes: AttributeContainer([.font: oldFont]))
        }
    }

}
