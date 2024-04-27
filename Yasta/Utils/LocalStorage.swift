//
//  LocalStorage.swift
//  Yasta
//
//  Created by Antonio Cranga on 06.04.2024.
//

import Foundation

@propertyWrapper
struct UserDefault<T: PropertyListValue> {
    let key: Key

    var wrappedValue: T? {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }
}

protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}

struct Key: RawRepresentable {
    let rawValue: String
}

extension Key: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

extension Key {
    static let dailyGoal: Key = "dailyGoal"
    static let caloriesGoal: Key = "caloriesGoal"
    static let distanceGoal: Key = "distanceGoal"
}

struct LocalStorage {
    static let shared = LocalStorage()

    @UserDefault(key: .dailyGoal)
    var dailyGoal: Int?
    @UserDefault(key: .caloriesGoal)
    var caloriesGoal: Int?
    @UserDefault(key: .distanceGoal)
    var distanceGoal: Int?
}
