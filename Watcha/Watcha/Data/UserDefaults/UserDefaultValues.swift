//
//  UserDefaultValues.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public struct UserDefaultValues {
 
    @UserDefault (key: "favoriteIDList")
    public static var favoriteIDList: [String]?
}

@propertyWrapper
public struct UserDefault<Value> {
    let key: String

    public var wrappedValue: Value? {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
