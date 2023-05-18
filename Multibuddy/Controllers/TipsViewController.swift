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
        ["tip": """
Multiples of 2 will always end in 2, 4, 6, 8 (or 0).
""",
         "example": """
Memorize this song: 2, 4, 6, 8, who do we appreciate? Zero!
"""],

        ["tip": """
If the sum of the number's digits is a multiple of 3, then the original number is also \
a multiple of 3.
""",
         "example": """
24 is a multiple of 3 because: 2 + 4 = 6, and 6 is a multiple of 3.
"""],

        ["tip": """
If you halve the tens and ones part of a number and the result is even, then the number is \
a multiple of 4.
""",
         "example": """
24 / 2 = 12. 12 is even, so 24 is a multiple of 4.
"""],

        ["tip": """
If the last digit is 0 or 5, then the number is a multiple of 5.
""",
         "example": """
0, 5, 10, 35...
"""],

        ["tip": """
If the above rules for 2 and 3 both work (meaning the number is a multiple of both 2 \
and 3) then it is a multiple of 6.
""",
         "example": """
18 ends in 8, so it's a multiple of 2. Also: its digits add up to 9, which is a multiple of 3. \
Therefore we know 18 is a multiple of 6.
"""],

        ["tip": """
If the difference between twice the ones digit of the number and the rest of the number \
is a multiple of 7 (or is equal to 0), then the number is a multiple of 7.
""",
         "example": """
35 is a multiple of 7, because:
The ones digit of 35 is 5.
Doubling 5 we get 10.
The rest of the number is 3.
The difference between 3 and 10 is 7 (or -7, doesn't matter!)
"""],

        ["tip": """
the tip is to drink tea
""",
         "example": """
make a tea and drink it
"""],

        ["tip": """
the tip is to drink tea
""",
         "example": """
make a tea and drink it
"""],

        ["tip": """
the tip is to drink tea
""",
         "example": """
make a tea and drink it
"""]]


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tips 💡"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.separatorStyle = .none

    }


    // MARK: TableView Delegate

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return Const.baseOptions.count
    }


    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Const.tipsCell)
        as! TipsTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = """
        Spot Multiples of: \(indexPath.row + Const.fakeIndexOffset)
        """

        cell.tipLabel.text = """
        ✅ \(tipsDict[indexPath.row]["tip"]!)
        """

        cell.exampleLabel.text = """
        📝 \(tipsDict[indexPath.row]["example"]!)
        """

        return cell
    }

}
