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
    // TODO:
    // SORTED by priority
    // 1. remove/update storing of completed levels
    // 2. music and sound effects
    // 3. show at end of level what user got wrong/right


    // MARK: Life Cycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

                if CommandLine.arguments.contains("--multibuddyScreenshots") {
                    // We are in testing mode, make arrangements
                    ud.set(true, forKey: Const.userSawSettings)
                    ud.set("", forKey: Const.completedLevels)
                }

                ud.register(defaults: [
                    Const.userSawSettings: false,
                    Const.completedLevels: "",
                    Const.base: 7
                ])

                return true
            }

}
