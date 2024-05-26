//
//  LookingForScenePresenter.swift
//  HomeForYou
//  Created by Aung Ko Min on 4/8/23.
//  Copyright (c) 2023 Aung Ko Min. All rights reserved.
//

import Foundation
import XUI

protocol LookingForScenePresentationLogic {
    func present(response: LookingForScene.Response)
    func displayError(_ error: Error)
    func displayItems(_ items: Loadable<LazyList<Looking>>)
}

final class LookingForScenePresenter {

    var view: LookingForSceneDisplayLogic?

    deinit {
        print("\(LookingForScene.self) Presenter Deinit")
    }
}

extension LookingForScenePresenter: LookingForScenePresentationLogic {

    @MainActor func displayItems(_ items: XUI.Loadable<XUI.LazyList<Looking>>) {
        view?.displayItems(items)
    }

    @MainActor func displayError(_ error: Error) {
        view?.displayError(error)
    }

    @MainActor func present(response: LookingForScene.Response) {
        let viewModel = LookingForScene.ViewModel()
        view?.display(viewModel: viewModel)
    }
}
