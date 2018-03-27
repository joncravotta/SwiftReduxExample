//
//  User.swift
//  ReduxExample
//
//  Created by Alessandro Martin on 03/27/2018.
//  Copyright © 2018 Jonathan Cravotta. All rights reserved.
//

struct User {
    var name: String
    var zipcode: Int
    var sizes: [Int]
    
    static let anonymous = User(name: "Anonymous", zipcode: 90210, sizes: [])
}

// Note: equatable conformance for types like this should be automatic in Swift 4.1
extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name
            && lhs.zipcode == rhs.zipcode
            && lhs.sizes == rhs.sizes
    }
}

//MARK: - Reducer
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

//MARK: - Actions
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
