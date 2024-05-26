//
//  PostingFlowRouter.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/5/24.
//

import Foundation
import XUI

@Observable
final class PostingFlowRouter {
    
    var path = [PostingFlow]()
    
    deinit {
        Log("deinit postingFlowRouter")
    }
}
