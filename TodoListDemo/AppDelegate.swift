//
//  AppDelegate.swift
//  TodoListDemo
//
//  Created by Admin on 12/12/22.
//

import UIKit

import RealmSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Did finish with options")
        // Override point for customization after application launch.
        
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do {
            _ = try Realm()
            
        }catch {
            print("Error handling new realm \(error)")
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("")
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

