//
//  AppDelegate.swift
//  Multibuddy
//
//  Created by Daniel Springer on 01/07/2018.
//  Copyright © 2023 Daniel Springer. All rights reserved.
//

import UIKit


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {


    // MARK: Properties

    var window: UIWindow?

    // TODO: todos
    // test kid-adult-boomer
    // Improve design of level ended alert, merge/remove "your score" behind alert, should be in alert, and behind alert just play again buttons (?or maybe alert should have nextLevel, playAgain, Back..), also showing 1100 points when goal is 1k is irrelevant.. maybe instead of alert show actual vc
    // maybe show score vs score needed as progress bar filling up
    // ?lives left -> lives used, with emojis for none, or all but 1 etc
    // ?don't show same number twice in a row


    // MARK: Life Cycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

                if CommandLine.arguments.contains("--multibuddyScreenshots") {
                    // We are in testing mode, make arrangements
                    ud.set("", forKey: Const.completedLevels)
                }

                ud.register(defaults: [
                    Const.completedLevels: "",
                    Const.userSawSplash: false
                ])

                return true
            }

}
