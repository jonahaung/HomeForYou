//
//  LookingForSceneInteractor.swift
//  HomeForYou
//  Created by Aung Ko Min on 4/8/23.
//  Copyright (c) 2023 Aung Ko Min. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import XUI

protocol LookingForSceneBusinessLogic {
    func task() async
}

final class LookingForSceneInteractor: @unchecked Sendable {

    var presenter: LookingForScenePresentationLogic?

    deinit {
        Log("\(LookingForScene.self) Interactor Deinit")
    }
}

extension LookingForSceneInteractor: LookingForSceneBusinessLogic {

    func task() async {
        presenter?.displayItems(.loading)
        let query = Firestore.firestore().collection("looking")
        let request = LookingForScene.Request(query: query)
        do {
            let lookings: [Looking] = try await Repo.shared.async_fetch(query: request.query)
            await MainActor.run {
                presenter?.displayItems(.loaded(value: lookings.lazyList, isLoadingMore: false))
            }
        } catch {
            presenter?.displayError(error)
        }
    }

}
