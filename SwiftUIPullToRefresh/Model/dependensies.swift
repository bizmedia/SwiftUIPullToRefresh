//
//  dependensies.swift
//  SwiftUIPullToRefresh
//
//  Created by Туков Анатолий on 04.11.2019.
//  Copyright © 2019 Туков Анатолий. All rights reserved.
//

import Foundation

struct Dependencies {
    var dogsService: DogsAPI
}

let dependencies = Dependencies(
    dogsService: DogsAPI()
)
