//
//  LookingForSceneView.swift
//  HomeForYou
//  Created by Aung Ko Min on 4/8/23.
//  Copyright (c) 2023 Aung Ko Min. All rights reserved.
//

import SwiftUI
import XUI

struct LookingForSceneView: View {

    @State private var interactor: LookingForSceneBusinessLogic?
    @ObservedObject private var datastore: LookingForSceneDataStore

    init() {
        let interactor = LookingForSceneInteractor()
        let presenter = LookingForScenePresenter()
        let datastore = LookingForSceneDataStore()
        _interactor = .init(wrappedValue: interactor)
        _datastore = .init(wrappedValue: datastore)
        interactor.presenter = presenter
        presenter.view = datastore
    }

    @ViewBuilder
    private func content(_ result: Loadable<LazyList<Looking>>) -> some View {
        switch result {
        case .loading:
            LoadingIndicator()
        case .loaded(let value, _):
            List {
                ForEach(value) { looking in
                    Text(looking.title)
                }
            }
        case .failed(let error):
            ErrorView(error: error) {
                Task {
                    await interactor?.task()
                }
            }
        }
    }

    var body: some View {
        content(datastore.items)
            .navigationTitle("Looking For")
            .task {
                await interactor?.task()
            }
    }
}

extension LookingForSceneView {

}
