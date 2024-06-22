//
//  ViewLazyUpdater.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 23/6/24.
//

import Foundation

public final class ViewLazyUpdater: ObservableObject {
    
    public typealias Work = () -> Void
    
    @Published public var blockOperations = [Work]()
    
    public func insert(_ block: @escaping Work) {
        blockOperations.append(block)
    }
    public func handleUpdates() {
        blockOperations.forEach { $0() }
        blockOperations.removeAll()
    }
}
