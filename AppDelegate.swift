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
    // lives left -> lives used, with emojis for none, or all but 1 etc
    // don't show same number twice in a row
    // accessibility: voice control, voiceover, kid adult boomer
    // ?show tips page - or point to tips button - on first time
    // Improve design of level ended alert
    // ?allow setting difficulty (higher score, less lives, less time)
    // ?add more levels?


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
