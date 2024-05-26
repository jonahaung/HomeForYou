//
//  SearchingDataStore.swift
//  HomeForYou
//  Created by Aung Ko Min on 3/8/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI
import XUI

@Observable
final class SearchingViewModel: ViewModel {
    
    var alert: XUI._Alert?
    var loading: Bool = false
    
    var searchText = String() {
        willSet {
            guard newValue != searchText else { return }
            self.didChangeSearchText(newValue)
        }
    }
    var responses: [Searching.Response] = SearchStorage.responses
    private var cancelBag = CancelBag()
    
    private var keywordsWorker = KeywordsSearchingWorker()
    private var resultsFactoryWorker = SearchResultsFactoryWorker()
    private var localSearchWorker = LocalSearchWorker()
    private var filtersParser = FiltersParser()
    
    var selectedTokens = [KeyWord]()
    
    deinit {
        print("SearchingViewModel Deinit")
    }
    
    func display(responses: [Searching.Response]) {
        self.responses = responses
    }
    
    func didChangeSearchText(_ text: String) {
        if text.isWhitespace {
            displayHistory()
            return
        }
        localSearchWorker.search(text) { [weak self] keywords in
            guard let self else { return }
            var keywords = keywords
            keywords.append(contentsOf: self.keywordsWorker.search(text: text))
            
            DispatchQueue.main.async {
                let results = self.resultsFactoryWorker.create(keywords: keywords, searchText: text).filter { response in
                    !self.selectedTokens.contains(response.keyword)
                }
                guard !results.isEmpty else {
                    self.displayHistory()
                    return
                }
                self.responses = results
            }
        }
    }
    
    func onSubmitSearch(_ token: KeyWord) {
        SearchStorage.insert(text: token.keyValueString)
        selectedTokens.append(token)
        searchText.removeAll()
    }
    @MainActor
    func onSubmitSearch() {
        @Injected(\.router) var router
        router.push(to: SceneItem(
            .postCollection, data: [PostFilter(
                .keywords,
                selectedTokens.map{ $0.keyValueString }
            )])
        )
    }
    private func displayHistory() {
        responses = SearchStorage.responses
    }
}
