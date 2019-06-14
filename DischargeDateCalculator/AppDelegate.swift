//
//  AppDelegate.swift
//  Navigation
//
//  Created by Min Kyeong Tae on 01/12/2018.
//  Copyright © 2018 Min Kyeong Tae. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1161737894053314~6639259886") //내 애드몹 아이디가 뭐더라?

        // Override point for customization after application launch.

        return true
    }

}

