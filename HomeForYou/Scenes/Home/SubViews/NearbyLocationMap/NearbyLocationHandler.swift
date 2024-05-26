//
//  NearbyLocationHandler.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 22/5/24.
//

import Foundation
import CoreLocation
import XUI
import Combine
import FirebaseFirestore

final class NearbyLocationHandler: ViewModel, ObservableObject {
    
    @Published var currentLocation: CLLocationCoordinate2D?
    var geoHash: String?
    @Published var nearbyPosts = [Post]()
    private var cancelBag = CancelBag()
    var alert: XUI._Alert?
    var loading: Bool = false
    
    init() {
        $currentLocation
            .removeDuplicates()
            .compactMap{ $0?.geohash(length: 6)}
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] geoHash in
                guard let self else { return }
                await MainActor.run {
                    self.geoHash = geoHash
                }
                let nearbyPosts = await self.getNearbyPosts(for: geoHash, .current)
                await MainActor.run {
                    self.nearbyPosts = nearbyPosts
                }
            }
            .store(in: cancelBag)
    }
    
    func getNearbyPosts(for geoHash: String, _ category: Category) async -> [Post]{
        let query = collectionReference(category).whereField(PostKeys.geoHash.rawValue, isGreaterThanOrEqualTo: geoHash)
            .whereField(PostKeys.geoHash.rawValue, isLessThan: geoHash + "\u{f8ff}").order(by: PostKeys.geoHash.rawValue, descending: true)
        return await getPosts(for: query)
    }
    func onUpdateCategory(_ category: Category) async {
        guard let geoHash else {
            return
        }
        self.nearbyPosts = await getNearbyPosts(for: geoHash, category)
    }
    private func collectionReference(_ category: Category) -> CollectionReference {
        Firestore.firestore().collection(category.rawValue)
    }
    private func getPosts(for query: Query) async -> [Post] {
        do {
            return try await Repo.async_fetch(query: query)
        } catch {
            await showAlert(.init(error: error))
            return []
        }
    }
    @MainActor func getGeoHash() async -> String? {
        return geoHash
    }
    func refresh(_ category: Category) async {
        guard let geoHash = await getGeoHash() else { return }
        let nearbyPosts = await self.getNearbyPosts(for: geoHash, category)
        await MainActor.run {
            self.nearbyPosts = nearbyPosts
        }
    }
}
