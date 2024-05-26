//
//  AppReloader.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/8/23.
//

import Foundation
import XUI

@Observable
final class AppReloader {
    
    var showSplashScreen = true
    private let cancelBag = CancelBag()
    @ObservationIgnored @Injected(\.store) private var store: Store
    
    init() {
        registerReloadNotificatios()
    }
    func reload() {
        self.showSplashScreen = true
    }
    private func registerReloadNotificatios() {
        NotificationCenter
            .default
            .publisher(for: .L10nLanguageChanged)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.store.bulkUpdate { state in
                    state.ui = .init()
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.reload()
                    }
                }
            }
            .store(in: cancelBag)
    }
}
