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
    
    var alert: XUI._Alert?
    var loading: Bool = false
    var geoHash: String?
    var location: LocationInfo?
    @Published var nearbyPosts = [Post]()
    private let repo = Repo()
    private let locationPublisher = LocationPublisher()
    private var cancelBag = CancelBag()
    
    init() {
        locationPublisher.publisher()
            .removeDuplicates()
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                await self.setLoading(true)
                let geoHash = value.coordinate.geohash(length: 6)
                do {
                    let posts = await self.getNearbyPosts(for: geoHash, Category.current)
                    let info = try await GeoCoder.createLocationInfo(from: value)
                    await self.setLoading(false)
                    await MainActor.run {
                        self.geoHash = geoHash
                        self.location = info
                        self.nearbyPosts = posts
                    }
                } catch {
                    await showAlert(.init(error: error))
                }
            }
            .store(in: cancelBag)
        locationPublisher.startUpdatingLocation()
    }
}

extension NearbyLocationHandler {
    func onUpdateCategory(_ category: Category) async {
        guard let geoHash = await getGeohash() else {
            return
        }
        await setLoading(true)
        let nearbyPosts = await getNearbyPosts(for: geoHash, category)
        await MainActor.run {
            self.nearbyPosts = nearbyPosts
            setLoading(false)
        }
    }
    func refresh() {
        Task {
            await onUpdateCategory(.current)
        }
    }
}
extension NearbyLocationHandler {
    private func getNearbyPosts(for geoHash: String, _ category: Category) async -> [Post]{
        let query = Firestore.firestore().collection(category.rawValue).whereField(PostKeys.geoHash.rawValue, isGreaterThanOrEqualTo: geoHash)
            .whereField(PostKeys.geoHash.rawValue, isLessThan: geoHash + "\u{f8ff}").order(by: PostKeys.geoHash.rawValue, descending: true)
        return await getPosts(for: query)
    }
    
    private func getPosts(for query: Query) async -> [Post] {
        do {
            return try await repo.async_fetch(query: query)
        } catch {
            await showAlert(.init(error: error))
            return []
        }
    }
    @MainActor
    private func getGeohash() -> String? {
        geoHash
    }
}
