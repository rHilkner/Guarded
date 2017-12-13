//
//  AppDelegate.swift
//  Avast
//
//  Created by Rodrigo Hilkner on 06/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FBSDKCoreKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.


		UIApplication.shared.registerForRemoteNotifications()
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

		GMSPlacesClient.provideAPIKey("AIzaSyBJXlwXoEPfuCZrwQ9IAK86mxR5yBfp-Vs")
        
		/*WatchSessionManager.sharedManager.startSession(){
			(error) in
			if error {
				print("Não foi possível criar uma sessão com o watch")
			}
		}*/
                
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

	///handle the device token (probably send it to your server for later use)
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

		let tokenString = deviceToken.reduce("") { string, byte in
			string + String(format: "%02X", byte)
		}
		print("Device Token: \(tokenString)")
	}

	/// The errors are pretty explicit
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("Failed to register: \(error)")
	}

	/// 
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

		//handle received notification
		print(userInfo)
	}

}

