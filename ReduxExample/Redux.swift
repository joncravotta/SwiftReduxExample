//
//  Redux.swift
//  ReduxExample
//
//  Created by Jonathan Cravotta on 3/25/18.
//  Copyright © 2018 Jonathan Cravotta. All rights reserved.
//

import ReactiveSwift

protocol StateType {}
protocol Action {}

typealias Reducer<ReducerStateType> = (Action, ReducerStateType) -> ReducerStateType

final class Store<State: StateType> {

    let reducer: Reducer<State>
    let state: MutableProperty<State>

    init(reducer: @escaping Reducer<State>, state: State) {
        self.reducer = reducer
        self.state = MutableProperty(state)
    }

    func dispatch(action: Action) {
        state.value = reducer(action, state.value)
    }

    @discardableResult
    public func observeSignal<Part: Equatable>(keyPath: KeyPath<State,Part>, action: @escaping (Part) -> Void) -> Disposable? {
        return state.signal.combinePrevious().observeValues { previous, current in
            let previousPart = previous[keyPath: keyPath]
            let currentPart = current[keyPath: keyPath]

            if previousPart != currentPart {
                action(currentPart)
            }
        }
    }

    @discardableResult
    public func observeProducer<Part: Equatable>(keyPath: KeyPath<State,Part>, action: @escaping (Part) -> Void) -> Disposable {
        return state.producer.combinePrevious().startWithValues { previous, current in
            let previousPart = previous[keyPath: keyPath]
            let currentPart = current[keyPath: keyPath]

            if previousPart != currentPart {
                action(currentPart)
            }
        }
    }
}

// Example:

struct AppState: StateType {
    let user: User
    let appConfiguration: AppConfiguration

    static let initial = AppState(user: .anonymous, appConfiguration: .default)
}

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

struct TogglePushNotifications: Action {
    let enable: Bool
}

struct ToggleDarkTheme: Action {
    let enable: Bool
}

// Note: equatable conformance for types like this should be automatic in Swift 4.1
struct User: Equatable {
    var name: String
    var zipcode: Int
    var sizes: [Int]

    static let anonymous = User(name: "Anonymous", zipcode: 90210, sizes: [])

    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
            && lhs.zipcode == rhs.zipcode
            && lhs.sizes == rhs.sizes
    }
}

struct UserName: Action {
    let name: String
}

struct UserZipCode: Action {
    let zipcode: Int
}

struct UserSizes: Action {
    let sizes: [Int]
}

struct UserZipCodeAndSizes: Action{
    let zipcode: Int
    let sizes: [Int]
}

func appReducer(_ action: Action, _ state: AppState) -> AppState {
    return AppState(user: userReducer(action, state.user),
                    appConfiguration: appConfigurationReducer(action, state.appConfiguration))
}

func userReducer(_ action: Action, _ state: User) -> User {
    var newState = state

    switch action {
    case let action as UserName:
        newState.name = action.name
    case let action as UserZipCode:
        newState.zipcode = action.zipcode
    case let action as UserSizes:
        newState.sizes = action.sizes
    case let action as UserZipCodeAndSizes:
        newState.zipcode = action.zipcode
        newState.sizes = action.sizes
    default:
        break
    }

    return newState
}

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
