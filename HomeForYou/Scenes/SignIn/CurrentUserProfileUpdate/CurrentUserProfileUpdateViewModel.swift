//
//  CurrentUserProfileUpdateViewModel.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 5/5/24.
//

import UIKit
import FirebaseAuth
import FireAuthManager
import FirebaseStorage
import Nuke
import XUI

@Observable
class CurrentUserProfileUpdateViewModel: ViewModel {
    
    var pickedImage: UIImage?
    
    let profileUpder = CurrentUserProfileUpdater()
    var alert: XUI._Alert?
    var loading: Bool = false
    
    func updateProfile(to currentUser: CurrentUser) async {
        guard let user = currentUser.user else { return }
        await setLoading(true)
        do {
            if pickedImage != nil {
                let url = try await uploadProfilePhoto(to: currentUser)
                pickedImage = nil
                try await profileUpder.update(.photoURL(url.absoluteString), user: user)
            }
            if user.displayName != currentUser.displayName {
                try await profileUpder.update(.displayName(currentUser.displayName.trimmed), user: user)
            }
            if user.photoURL?.absoluteString != currentUser.photoURL {
                try await profileUpder.update(.photoURL(currentUser.photoURL), user: user)
            }
            await setLoading(false)
        } catch {
            await showAlert(.init(error: error))
        }
    }
    func hasUpdates(_ currentUser: CurrentUser) -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        return user.displayName?.trimmed != currentUser.displayName.trimmed ||
        user.photoURL?.absoluteString != currentUser.photoURL || pickedImage != nil
    }
    
    func uploadProfilePhoto(to currentUser: CurrentUser) async throws -> URL {
        if let pickedImage {
            let cropProcessor = ImageProcessors.Resize(size: CGSize(width: 150, height: 150), crop: true, upscale: true)
            let circleProcessor = ImageProcessors.Circle(border: ImageProcessingOptions.Border.init(color: .white, width: 2))
            if
                let crop = cropProcessor.process(pickedImage),
                let circled = circleProcessor.process(crop),
                let data = circled.pngData() {
                let ref = Storage.storage().reference(withPath: "profilePhotos").child(currentUser.uid)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                _ = try await ref.putDataAsync(data, metadata: metadata)
                return try await ref.downloadURL()
            } else {
                fatalError()
            }
        } else {
            fatalError()
        }
    }
}
