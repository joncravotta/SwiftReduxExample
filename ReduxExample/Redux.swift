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
