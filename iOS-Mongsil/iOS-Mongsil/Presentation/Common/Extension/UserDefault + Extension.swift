//
//  UserDefault + Extension.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/03/12.
//

import Foundation

extension UserDefaults {
    public static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        
        return isFirstLaunch
    }
}
