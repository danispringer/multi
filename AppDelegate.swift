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
    // show tricks for each multiple
    // music and sound effects
    // show at end of level what user got wrong/right
    // let users reset done levels (unless no longer marked as done)


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
