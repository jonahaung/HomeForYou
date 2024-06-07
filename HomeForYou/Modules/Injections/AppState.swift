//
//  XApp.swift
//  Msgr
//
//  Created by Aung Ko Min on 18/1/23.
//

import XUI
import Firebase
import FirebaseFirestore
import FireAuthManager
import SecureStorage

struct AppState {
    
    var utils = Utils()
    var currentUser: CurrentUser
    var ui = UI()
    var router = Router()
    
    init() {
        FirebaseApp.configure()
        currentUser = .init()
        if !SecureStorage.shared.isKeyCreated {
            SecureStorage.shared.password = Auth.auth().currentUser?.uid ?? ""
        }
    }

    func configure() {
        AppStateProviderKey.currentValue = Store(self)
    }
}

private struct AppStateProviderKey: InjectionKey {
    static var currentValue: Store<AppState>?
}

extension InjectedValues {
    
    var store: Store<AppState> {
        get {
            guard let injected = Self[AppStateProviderKey.self] else { fatalError("App was not setup") }
            return injected
        }
        set { Self[AppStateProviderKey.self] = newValue }
    }
    
    var utils: Utils {
        get { store.value.utils }
        set {
            store.bulkUpdate { state in
                state.utils = newValue
            }
        }
    }
    
    var currentUser: CurrentUser {
        get { store.value.currentUser }
        set {
            store.value.currentUser = newValue
            store.bulkUpdate { state in
                state.currentUser = newValue
            }
        }
    }
    var router: Router {
        get { store.value.router }
        set {
            store.value.router = newValue
            store.bulkUpdate { state in
                state.router = newValue
            }
        }
    }
    var ui: UI {
        get { store.value.ui }
        set {
            store.bulkUpdate { state in
                state.ui = newValue
            }
        }
    }
}
