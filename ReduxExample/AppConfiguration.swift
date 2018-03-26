//
//  AppConfiguration.swift
//  ReduxExample
//
//  Created by Alessandro Martin on 03/27/2018.
//  Copyright © 2018 Jonathan Cravotta. All rights reserved.
//

// Note: equatable conformance for types like this should be automatic in Swift 4.1
struct AppConfiguration: Equatable {
    var arePushNotificationsEnabled: Bool
    var isDarkThemed: Bool

    static let `default` = AppConfiguration(arePushNotificationsEnabled: false, isDarkThemed: false)

    static func ==(lhs: AppConfiguration, rhs: AppConfiguration) -> Bool {
        return lhs.arePushNotificationsEnabled == rhs.arePushNotificationsEnabled
            && lhs.isDarkThemed == rhs.isDarkThemed
    }
}

//MARK: - Reducer
func appConfigurationReducer(_ action: Action, _ state: AppConfiguration) -> AppConfiguration {
    var newState = state

    switch action {
    case let action as TogglePushNotifications:
        newState.arePushNotificationsEnabled = action.enable
    case let action as ToggleDarkTheme:
        newState.isDarkThemed = action.enable
    default:
        break
    }

    return newState
}

//MARK: - Actions
struct TogglePushNotifications: Action {
    let enable: Bool
}

struct ToggleDarkTheme: Action {
    let enable: Bool
}
