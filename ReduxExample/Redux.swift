//
//  GenericRedux.swift
//  ReduxExample
//
//  Created by Jonathan Cravotta on 3/25/18.
//  Copyright © 2018 Jonathan Cravotta. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol Store {
    associatedtype State
    associatedtype Action
    
    var state: MutableProperty<State> { get }
    func reducer(_ action: Action, _ state: State) -> State
}

extension Store {
    func dispatch(action: Action) {
        state.value = reducer(action, state.value)
    }
}

// Example:
struct User {
    var name: String
    var zipcode: Int
    var sizes: [Int]
}

enum UserAction {
    case updateName(String)
    case updateZip(Int)
    case updateSizes([Int])
    case updateZipAndSizes(zip: Int, sizes: [Int])
}

class UserStore: Store {
    
    typealias Action = UserAction
    typealias State = User
    
    var state: MutableProperty<User>

    init(user: User) {
        self.state = MutableProperty(user)
    }
    
    func reducer(_ action: Action, _ state: User) -> User {
        var newState = state
        
        switch action {
        case .updateName(let name): newState.name = name
        case .updateZip(let zip): newState.zipcode = zip
        case .updateSizes(let sizes): newState.sizes = sizes
            
        case let .updateZipAndSizes(zip, sizes):
            newState.zipcode = zip
            newState.sizes = sizes
        }
        
        return newState
    }
}


//:D
extension MutableProperty {
    @discardableResult
    public func observeProducer(_ value: @escaping (MutableProperty.Value) -> Void) -> Disposable {
        return producer.startWithValues(value)
    }
    
    @discardableResult
    public func observeSignal(_ value: @escaping (MutableProperty.Value) -> Void) -> Disposable? {
        return signal.observeValues(value)
    }
}


