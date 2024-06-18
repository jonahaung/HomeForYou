//
//  PostingFlowViewModel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 18/6/24.
//

import Foundation
import XUI

final class PostUploaderViewModel: ObservableObject, ViewModel {
    
    @Published var alert: XUI._Alert?
    @Published var loading: Bool = false
    private let postUploader = PostUploader()
    
    func post(_ postingData: inout any Postable) async {
        await setLoading(true)
        do {
            try await postUploader.post(&postingData)
            await setLoading(false)
        } catch {
            await showAlert(.init(error: error))
        }
    }
}
