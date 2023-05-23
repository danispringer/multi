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
    // music & sound effects
    // After ending a level, show me what I got right or wrong
    // more levels
    // allow setting difficulty (higher score, less lives, less time)
    // show correct multiples more often
    // fix tips button going past bottom of navbar when navbar is shrunk
    // allow setting lives to endless but with timer (and: without timer?), as in: leaderboard
    //   of high scores in X time, regardless of lives lost (or maybe set to 1 life?)
    // make tips button more noticeable? (glow?) maybe show tips page on first time, maybe more
    // than once, with "remind me", "don't show again" buttons


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
