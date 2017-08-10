//
//  Defaults.swift
//  diff
//
//  Created by Ryan Farley on 8/10/17.
//  Copyright © 2017 Perf. All rights reserved.
//

import UIKit

struct Defaults {
    static var fontSize: CGFloat {
        get {
            return UserDefaults.standard.object(forKey: "SavedFontSize") as? CGFloat ?? 12
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "SavedFontSize")
            defaults.synchronize()
        }
    }
}
