//
//  AuthState.swift
//  ReduxState
//
//  Created by Туков Анатолий on 20.10.2019.
//  Copyright © 2019 Туков Анатолий. All rights reserved.
//

import Foundation
import Combine



struct DogState: Equatable {
    var loading: Bool = false
    var id: Int = 0
    var dog: Dog = dependencies.dogsService.dogs[0]
}

struct Dog: Identifiable, Equatable {
    let id = UUID()
    let name:String
    let picture: String
    let origin: String
    var description: String = ""
}

/// Maps Auth related actions to mutations
enum DogAction: Action {
    case getNextDog
    
    /// Maps Auth related actions to mutations
    func mapToMutation() -> AnyPublisher<DogMutation, Never> {
        switch self {
        case .getNextDog:
            return dependencies.dogsService
                .getNextDogPublisher(sharedReduxStore.state.dog.id)
                .map {
                   DogMutation.setDogResult($0)
            }.eraseToAnyPublisher()
        }
    }
}

/// Authenthication related mutations
enum DogMutation {
    case setDogResult(_ result: DogPayload)
}

let dogReducer: Reducer<DogState, DogAction.Mutation> = { state, mutation in
    switch mutation {
    case .setDogResult(let result):
        state.id = result.id
        state.dog = result.dog
        state.loading = false
    }
}
