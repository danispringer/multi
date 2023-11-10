//
//  TipsViewController.swift
//  Multibuddy
//
//  Created by dani on 5/17/23.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

class TipsViewController: UITableViewController {


    // MARK: Properties

    let tipsDict: [[String: String]] = [
        [
            "tip":
"""
If the number ends in 2, 4, 6, 8 (or 0), then it is a multiple of 2.
""",
            "example":
"""
Memorize this song: 2, 4, 6, 8, who do we appreciate? Zero!
"""
        ],
        [
            "tip":
"""
If the sum of the number's digits is a multiple of 3, then the original number is also \
a multiple of 3.
""",
            "example":
"""
24 is a multiple of 3 because 2 + 4 = 6, and 6 is a multiple of 3.
"""
        ],

        [
            "tip":
"""
If you halve the tens and ones part of a number and the result is even, then the number is \
a multiple of 4.
""",
            "example":
"""
24 / 2 = 12. 12 is even, so 24 is a multiple of 4.
"""
        ],

        [
            "tip":
"""
If the number ends in 0 or 5, then it is a multiple of 5.
""",
            "example":
"""
0, 5, 10, 35...
"""
        ],

        [
            "tip":
"""
If the number is a multiple of 2 and 3, then it is a multiple of 6.
""",
            "example":
"""
18 ends in 8, so it's a multiple of 2. Also: its digits add up to 9, which is a \
multiple of 3. Therefore we know 18 is a multiple of 6.
"""
        ],

        [
            "tip":
"""
If the difference between twice the ones digit of the number and the rest of the number \
is a multiple of 7 (or is equal to 0), then the number is a multiple of 7.
""",
            "example":
"""
35 is a multiple of 7 because:
The ones digit of 35 is 5.
Doubling 5, we get 10.
The rest of the number is 3.
The difference between 3 and 10 is 7 (or -7, it doesn't matter!)
"""
        ],

        [
            "tip": """
By writing the results for 8x1, 8x2, 8x3, etc, on a paper, writing each result below \
the previous one, you can notice that the ones digits occur in the sequence: 8, 6, 4, 2, 0, \
while in the tens place, the numbers increase by 1 (almost) every time.
""",
            "example":
"""
\n08
16
24
32
40
48
56
64
72
80
"""
        ],

        [
            "tip":
"""
If the sum of the number's digits is a multiple of 9 (or simply 9), then the original number \
is also a multiple of 9.
""",
            "example":
"""
45 is a multiple of 9 because 4 + 5 = 9.
"""
        ],

        [
            "tip":
"""
If the number ends in 0, then it is a multiple of 10.
""",
            "example":
"""
20, 40, 50, 170, 990...
"""
        ]]


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Const.tipsTitle
        self.accessibilityLabel = emojiless(original: Const.tipsTitle)
        tableView.separatorStyle = .none
    }


    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return Const.optionsWithTips.count
    }


    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Const.tipsCell)
        as! TipsTableViewCell
        cell.selectionStyle = .none

        let rawTitleLabel = "Multiples of \(indexPath.row + Const.fakeIndexOffset)"
        cell.titleLabel.text = isVOOn ? emojiless(original: rawTitleLabel) : rawTitleLabel
        cell.titleLabel.accessibilityLabel = emojiless(original: cell.titleLabel.text!)

        let rawTipLabelText = "✅ \(tipsDict[indexPath.row]["tip"]!)"
        cell.tipLabel.text = isVOOn ? emojiless(original: rawTipLabelText)
        : rawTipLabelText
        cell.tipLabel.accessibilityLabel = emojiless(original: cell.tipLabel.text!)

        let rawExampleText = "📝 \(tipsDict[indexPath.row]["example"]!)"
        cell.exampleLabel.text = isVOOn ? emojiless(original: rawExampleText) : rawExampleText
        cell.exampleLabel.accessibilityLabel = emojiless(original: cell.exampleLabel.text!)

        return cell
    }

}
