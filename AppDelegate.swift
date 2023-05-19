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
    // music & sound effects
    // After ending a level, show me what I got right or wrong


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
