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

    let tipsArray = [
"""
2Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
""",
"""
3Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
""",
"""
L4orem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
""",
"""
5Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
""",
"""
L6orem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
""",
"""
7Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
""",
"""
L8orem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
""",
"""
L9orem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
""",
"""
10Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
"""
    ]


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tips 💡"
        navigationController?.navigationBar.prefersLargeTitles = true
    }


    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return tipsArray.count
    }


    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let fakeIndexPathRow = indexPath.row + 2
        // cuz row #1 is index 0 (and since multiples of 1 are irrelevant, we start at "2")

        let cell = tableView.dequeueReusableCell(withIdentifier: Const.tipsCell)
        as! TipsTableViewCell
        cell.selectionStyle = .none
        cell.primaryLabel.text = """
        How to Spot Multiples of: \(fakeIndexPathRow)
        """

        cell.secondaryLabel.text = tipsArray[indexPath.row]

        cell.layer.borderColor = myThemeColor.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 40

        return cell
    }

}
