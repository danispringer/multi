//
//  Const.swift
//  MultiBuddy
//
//  Created by Daniel Springer on 11/26/18.
//  Copyright © 2024 Daniel Springer. All rights reserved.
//

import UIKit

// swiftlint:disable:next identifier_name
let ud = UserDefaults.standard
let myThemeColor: UIColor = .magenta
let isVOOn = UIAccessibility.isVoiceOverRunning

struct Const {

    static let appVersion = "CFBundleShortVersionString"
    static let version = "v."
    static let appName = "MultiBuddy"
    static let contact = "Email me"
    static let reset = "Erase progress"
    static let emailString = "00.segue_affix@icloud.com"
    static let cancel = "Cancel"
    static let leaveReview = "Leave a review"
    static let reviewLink = "https://apps.apple.com/app/id6449202900?action=write-review"
    static let showAppsButtonTitle = "More By Daniel Springer"
    static let appsLink = "https://apps.apple.com/developer/id1402417666"
    static let okMessage = "OK"
    static let correctMessage = "Correct"
    static let tipsTitle = isVOOn ? "Tips" : "💡 Tips"
    static let doneMessage = "Done"
    static let oddMessage = "Odd"
    static let evenMessage = "Even"
    static let shareTitleMessage = "Tell a friend"
    static let myCollectionViewController = "MyCollectionViewController"
    static let aLevelViewController = "aLevelViewController"
    static let tipsViewController = "TipsViewController"
    static let yesMessage = "Yes"
    static let noMessageGame = "Nope"
    static let someLevelCell = "SomeLevelCell"
    static let tipsCell = "tipsCell"

    // MARK: UserDefaults
    static let levelIndexKey = "levelIndexKey"
    static let completedLevels = "completedLevels2"
    static let userSawSplash = "userSawSplash2"

    static let pointsPerTap = 100
    static let timerSeconds: Float = 59
    static let livesPerLevel = 3
    static let pointsGoal = 10 * pointsPerTap
    static let baseOptions = Array(1...100)
    static let optionsWithTips = Array(1...10)
    static let fakeIndexOffset: Int = baseOptions.first!

}
