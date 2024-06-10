//
//  LookingForSceneDataStore.swift
//  HomeForYou
//  Created by Aung Ko Min on 4/8/23.
//  Copyright (c) 2023 Aung Ko Min. All rights reserved.
//

import SwiftUI
import XUI

protocol LookingForSceneDisplayLogic {
    func display(viewModel: LookingForScene.ViewModel)
    func displayError(_ error: Error)
    func displayItems(_ items: Loadable<LazyList<Looking>>)
}

final class LookingForSceneDataStore: ObservableObject {

    @Published var error: Error?
    @Published var viewModel = LookingForScene.ViewModel()
    @Published var items: Loadable<LazyList<Looking>> = .loading

    deinit {
        Log("\(LookingForScene.self) DataStore Deinit")
    }
}

extension LookingForSceneDataStore: LookingForSceneDisplayLogic {

    func displayItems(_ items: XUI.Loadable<XUI.LazyList<Looking>>) {
        DispatchQueue.main.async {
            self.items = items
        }
    }

    func display(viewModel: LookingForScene.ViewModel) {
        DispatchQueue.main.async {
            self.viewModel = viewModel
        }
    }

    func displayError(_ error: Error) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
}
