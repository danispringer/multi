//
//  Const.swift
//  Multibuddy
//
//  Created by Daniel Springer on 11/26/18.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit

// swiftlint:disable:next identifier_name
let ud = UserDefaults.standard

struct Const {

    static let appVersion = "CFBundleShortVersionString"
    static let version = "v."
    static let appName = "Multibuddy"
    static let contact = "Email me"
    static let emailString = "00.segue_affix@icloud.com"
    static let cancel = "Cancel"
    static let leaveReview = "Leave a review"
    static let reviewLink = "https://apps.apple.com/app/id1406084758?action=write-review"
    static let showAppsButtonTitle = "More apps"
    static let appsLink = "https://apps.apple.com/developer/id1402417666"
    static let yesMessage = "Yes"
    static let noMessage = "No"
    static let okMessage = "OK"
    static let correctMessage = "Correct"
    static let doneMessage = "Done"
    static let oddMessage = "Odd"
    static let evenMessage = "Even"
    static let shareTitleMessage = "Tell a friend"
    static let BingoLevelsViewController = "BingoLevelsViewController"
    static let bingoViewController = "BingoViewController"
    static let bingoSettingsViewController = "BingoSettingsViewController"
    static let shabbosGameName = "Bingo"
    static let notBingoMessage = "Nope"
    static let bingoLevelCell = "levelCell"

    // UserDefaults
    static let userSawSettings = "userSawSettings"
    static let levelIndexKey = "levelIndexKey"
    static let completedBingoLevels = "completedBingoLevels2"
    static let base = "shabbosBase"

    static let pointsPerTap = 1
    static let timerSeconds: Float = 40
    static let bingoLevelsCount = 20
    static let rangeAddedPerLevel = 10
    static let livesPerLevel = 4
    static let pointsGoal = 20
    static let shabbosBaseOptions = Array(1...10)

}
