//
//  AppDelegate.swift
//  CoreData
//
//  Created by nguyen.duc.huyb on 6/7/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let _ = CoreDataManager.shared.saveContext()
    }
}

