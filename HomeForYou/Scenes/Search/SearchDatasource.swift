//
//  SearchingDataStore.swift
//  HomeForYou
//  Created by Aung Ko Min on 3/8/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI
import XUI

final class SearchDatasource: ObservableObject {
    
    @Published var isPresented = false
    var canPresentOnAppear = false
    @Published var searchText = String()
    
    @Published var searchScope: Search.Scope = .current { willSet { Search.Scope.current = newValue } }
    @Published var tokens = [KeyWord]()
    @Published var suggesstedTokens = [KeyWord]()
    
    @Published var result = Search.ResultType.suggestions
    
    private var addressAutoComplete = AddressAutoComplete()
    private let keywordSearchingWorker = KeywordsSearchingWorker()
    private let mrtSearchingWorker = MRTSearchingWorker()
    private let areaSearchingWorker = AreaSearchingWorker()
    
    private let resultsFactoryWorker = SearchResultsFactoryWorker()
    private let cancelBag = CancelBag()
    
    init() {
        $searchText
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                self.didChangeSearchText(value)
            }
            .store(in: cancelBag)
        
        $searchScope
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.onChangeSearchScope(value)
                }
            }
            .store(in: cancelBag)
        
        addressAutoComplete
            .$results
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                self.result = .results(self.resultsFactoryWorker.create(searchResults: value.map{ $0.fullAddress }, searchText: self.searchText))
            }
            .store(in: cancelBag)
    }
    deinit {
        Log("SearchingViewModel Deinit")
    }
}

extension SearchDatasource {
    private func didChangeSearchText(_ text: String) {
        guard !text.isWhitespace else {
            if tokens.isEmpty {
                result = .suggestions
            }
            return
        }
        switch searchScope {
        case .Address:
            addressAutoComplete.searchableText = text
        case .MRT:
            let results = mrtSearchingWorker.search(text: text)
            let searchResults = resultsFactoryWorker.create(searchResults: results, searchText: text)
            DispatchQueue.main.async {
                self.result = searchResults.isEmpty ? .emptyResults : .results(searchResults)
            }
        case .Area:
            let results = areaSearchingWorker.search(text: text)
            let searchResults = resultsFactoryWorker.create(searchResults: results, searchText: text)
            DispatchQueue.main.async {
                self.result = searchResults.isEmpty ? .emptyResults : .results(searchResults)
            }
        case .Keyword:
            let results = keywordSearchingWorker.search(text: text)
            let searchResults = resultsFactoryWorker.create(searchResults: results, searchText: text)
            DispatchQueue.main.async {
                self.result = searchResults.isEmpty ? .emptyResults : .results(searchResults)
            }
        }
    }
    @MainActor func onChangeSearchScope(_ scope: Search.Scope) {
        tokens.removeAll()
        let keywords = SearchStorage.keywords
        switch scope {
        case .Address:
            suggesstedTokens = keywords.filter{ $0.key == .address }
        case .MRT:
            suggesstedTokens = keywords.filter{ $0.key == .mrt }
        case .Area:
            suggesstedTokens = keywords.filter{ $0.key == .area }
        case .Keyword:
            suggesstedTokens = keywords.filter{ $0.key == .keywords }
        }
        didChangeSearchText(searchText)
    }
    @MainActor func onSelectSearchResult(_ text: String) {
        switch searchScope {
        case .Address:
            Task {
                do {
                    let location = try await GeoCoder.createLocationInfo(text)
                    await MainActor.run {
                        self.result = .location(location)
                        let address = location.address.text
                        let keyword = KeyWord(.address, address)
                        self.setKeyword(keyword)
                        self.searchText = String()
                    }
                } catch {
                    Log(error)
                }
            }
        case .MRT:
            let keyword = KeyWord(.mrt, text)
            setKeyword(keyword)
            searchText = String()
        case .Area:
            let keyword = KeyWord(.area, text.replace(" ", with: "_"))
            setKeyword(keyword)
            searchText = String()
        case .Keyword:
            let keyword = KeyWord(.keywords, text)
            setKeyword(keyword)
            searchText = String()
        }
    }
}

extension SearchDatasource {
    private func displayHistory() {
        tokens.removeAll()
        result = .suggestions
    }
    @MainActor func onAppear() {
        if canPresentOnAppear {
            isPresented = true
        }
        canPresentOnAppear = false
    }
    @MainActor func onDisAppear() {
        if !tokens.isEmpty || !searchText.isEmpty {
            canPresentOnAppear = true
        }
    }
    @MainActor func setKeyword(_ keyword: KeyWord) {
        guard !tokens.contains(keyword) else { return }
        tokens.append(keyword)
        SearchStorage.insert(text: keyword.keyValueString)
    }
}
