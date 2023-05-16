//
//  BingoSettingsViewController.swift
//  Multibuddy
//
//  Created by Daniel Springer on 10/31/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

class BingoSettingsViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var settingsTextView: UITextView!

    @IBOutlet weak var okButton: UIButton!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: update text: proofread

        settingsTextView.text = """
        Hey, welcome! 😊

        \(Const.appName) is here to help you know your times table like the back of your hands!

        What number do you want to practice the multiples of today?
        Choose your number below (you can always change this later)

        Next time you play, your goal will be to spot the multiples of \
        \(ud.integer(forKey: Const.base))

        (You can always see this tutorial later: tap "Settings" on the home page of the app
        """
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        settingsTextView.flashScrollIndicators()
    }


    // MARK: Helpers

    @IBAction func hidePressed(_ sender: Any) {
        dismiss(animated: true)
    }

}
