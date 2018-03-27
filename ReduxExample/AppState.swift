//
//  AppState.swift
//  ReduxExample
//
//  Created by Alessandro Martin on 03/27/2018.
//  Copyright © 2018 Jonathan Cravotta. All rights reserved.
//

struct AppState: StateType {
    let user: User
    let appConfiguration: AppConfiguration

    static let initial = AppState(user: .anonymous, appConfiguration: .default)
}

//MARK: - Reducer
func appReducer(_ action: Action, _ state: AppState) -> AppState {
    return AppState(user: userReducer(action, state.user),
                    appConfiguration: appConfigurationReducer(action, state.appConfiguration))
}
