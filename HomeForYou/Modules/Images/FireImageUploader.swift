//
//  FireImageUploader.swift
//  Msgr
//
//  Created by Aung Ko Min on 14/1/23.
//

import SwiftUI
import FirebaseStorage

class FireImageUploader: ObservableObject {

    enum Stage: Equatable {

        static func == (lhs: FireImageUploader.Stage, rhs: FireImageUploader.Stage) -> Bool {
            lhs.content == rhs.content
        }

        case Unknown
        case Progess(Double)
        case Success(URL)
        case Failure(Error)

        var content: String {
            switch self {
            case .Unknown:
                return "Unknown"
            case .Progess:
                return "Progress"
            case .Success:
                return "Success"
            case .Failure:
                return "Failure"
            }
        }
    }

    @Published var stage = Stage.Unknown

    func upload(_ image: UIImage, storageRef: StorageReference) {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uploadTask = storageRef.putData(data)

        uploadTask.observe(.progress) { [weak self] snapshot in
            guard let self, let progress = snapshot.progress else { return }
            let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
            self.stage = .Progess(percentComplete)
        }

        uploadTask.observe(.success) { [weak self] _ in
            storageRef.downloadURL { [weak self] url, error in
                guard let self else { return }
                DispatchQueue.main.async {
                    if let url {
                        self.stage = .Success(url)
                    } else if let error {
                        self.stage = .Failure(error)
                    }
                }
            }
        }
        uploadTask.observe(.failure) { [weak self] snapshot in
            guard let self else { return }
            if let error = snapshot.error {
                self.stage = .Failure(error)
            }
        }
    }
}
