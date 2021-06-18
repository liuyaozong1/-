//
//  AppDelegate.swift
//  LYZMediaPicker
//
//  Created by 刘耀宗 on 2021/6/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        let vc = ViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

  


}

