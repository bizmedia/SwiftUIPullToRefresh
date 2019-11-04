//
//  Store.swift
//  ReduxState
//
//  Created by Туков Анатолий on 20.10.2019.
//  Copyright © 2019 Туков Анатолий. All rights reserved.
//

import Foundation
import Combine

typealias Reducer<State, Mutation> = (inout State, Mutation) -> Void

protocol Action {
    associatedtype Mutation
    func mapToMutation() -> AnyPublisher<Mutation, Never>
}

enum AppAction: Action {
    case dog(action: DogAction)


    func mapToMutation() -> AnyPublisher<AppMutation, Never> {
        switch self {

        case let .dog(action):
            return action
                .mapToMutation()
                .map { AppMutation.dog(mutation: $0) }
                .eraseToAnyPublisher()
        }
    }
}

// State composition
struct ReduxAppState{
    var dog: DogState
}

// Reducer composition
enum AppMutation {
    case dog(mutation: DogMutation)
}

let appReducer: Reducer<ReduxAppState, AppAction.Mutation> = { state, mutation in
    switch mutation {
    
    case let .dog(mutation):
        dogReducer(&state.dog, mutation)
    }
}



final class ReduxStore<ReduxAppState, AppAction: Action>: ObservableObject {
    let publisher = PassthroughSubject<ReduxAppState, Never>()
    @Published var state: ReduxAppState{
        willSet { objectWillChange.send() }
        didSet {
            publisher.send(state)
        }
    }

    
    private let appReducer: Reducer<ReduxAppState, AppAction.Mutation>
    private var cancellables: Set<AnyCancellable> = []

    init(
        initialState: ReduxAppState,
        appReducer: @escaping Reducer<ReduxAppState, AppAction.Mutation>
    ) {
        self.state = initialState
        self.appReducer = appReducer
    }
    func send(_ action: AppAction) {
        action
            .mapToMutation()
            .receive(on: DispatchQueue.main)
            .sink { self.appReducer(&self.state, $0) }
            .store(in: &cancellables)
    }
}

class Observable<T>: ObservableObject, Identifiable {
    let id = UUID()
    let publisher = PassthroughSubject<T, Never>()
    
    @Published var state: T {
        willSet { objectWillChange.send() }
        didSet {
            publisher.send(state)
        }
    }
    init(_ initValue: T) {
        self.state = initValue
    }
}
