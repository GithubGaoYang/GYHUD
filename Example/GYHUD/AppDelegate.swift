//
//  AppDelegate.swift
//  GYHUD
//
//  Created by 高扬 on 01/21/2020.
//  Copyright (c) 2020 高扬. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.tintColor = UIColor(red: 0.337, green: 0.57, blue: 0.73, alpha: 1)
        return true
    }

}

