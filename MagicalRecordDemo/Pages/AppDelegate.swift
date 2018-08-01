//
//  AppDelegate.swift
//  MagicalRecordDemo
//
//  Created by yfm on 2018/7/31.
//  Copyright © 2018年 yfm. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // 初始化数据库
        MagicalRecord.setupCoreDataStack()
        MagicalRecord.setLoggingLevel(MagicalRecordLoggingLevel.all)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        let vc = ViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }

}

