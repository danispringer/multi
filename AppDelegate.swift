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
    // show correct multiples more often
    // ?fix tips button going past bottom of navbar when navbar is shrunk
    // allow setting lives to endless but with timer (and: without timer?), as in: leaderboard
    //   of high scores in X time, regardless of lives lost (or maybe set to 1 life?)
    // make tips button more noticeable? (glow?) maybe show tips page on first time, maybe more
    // than once, with "remind me", "don't show again" buttons.
    // music & sound effects
    // add more levels?
    // After ending a level, show both r and w? what if empty? improve design
    // allow setting difficulty (higher score, less lives, less time)


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
                    Const.completedLevels: ""
                ])

                return true
            }

}
