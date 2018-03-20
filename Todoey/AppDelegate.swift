//
//  AppDelegate.swift
//  Todoey
//
//  Created by Ahmet Canbazoglu on 14.03.18.
//  Copyright © 2018 F-Sane. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
 
    
    do {
         _ = try Realm()
       
        }
    catch
        {
    print("error new realm \(error)")
        }
    return true
    }
  


}

