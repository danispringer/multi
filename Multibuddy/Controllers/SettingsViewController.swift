//
//  SettingsViewController.swift
//  Multibuddy
//
//  Created by Daniel Springer on 10/31/22.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    // MARK: Outlets

    @IBOutlet weak var settingsTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var basePickerView: UIPickerView!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: update text: proofread

        refreshTextView()

        let fakeRowIndex = ud.integer(forKey: Const.base) - 1 // cuz row 0 has value "1"

        basePickerView.selectRow(fakeRowIndex, inComponent: 0,
                                 animated: false)

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        settingsTextView.flashScrollIndicators()
    }


    // MARK: Helpers

    @IBAction func hidePressed(_ sender: Any) {
        dismiss(animated: true)
    }


    func refreshTextView() {
        settingsTextView.text = """
        Hey, welcome! 😊

        \(Const.appName) is here to help you know your times table like the back of your hands!

        What number do you want to practice the multiples of today?
        Choose your number below (you can always change this later)

        Next time you play, your goal will be to spot the multiples of: \
        \(ud.integer(forKey: Const.base))

        (To see this tutorial later, tap "Settings" on the home page of the app)
        """
    }


    // MARK: Picker Delegate

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Const.baseOptions.count
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return "\(Const.baseOptions[row])"
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        ud.set(Const.baseOptions[row], forKey: Const.base)
        refreshTextView()
    }

}
