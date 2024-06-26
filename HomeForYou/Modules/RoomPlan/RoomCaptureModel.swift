//
//  RoomCaptureModel.swift
//  RoomPlan 2D
//
//  Created by Dennis van Oosten on 24/02/2023.
//

import Foundation
import RoomPlan
import XUI

class RoomCaptureModel: RoomCaptureSessionDelegate {
    static let shared = RoomCaptureModel()
    let roomCaptureView: RoomCaptureView
    private let captureSessionConfig: RoomCaptureSession.Configuration
    private let roomBuilder: RoomBuilder
    var finalRoom: CapturedRoom?
    
    func encode(with coder: NSCoder) {}
    
    required init?(coder: NSCoder) {
        fatalError("Error when initializing RoomCaptureModel")
    }
    private init() {
        roomCaptureView = RoomCaptureView(frame: .zero)
        captureSessionConfig = RoomCaptureSession.Configuration()
        roomBuilder = RoomBuilder(options: [.beautifyObjects])
        roomCaptureView.captureSession.delegate = self
    }
    
    func startSession() {
        roomCaptureView.captureSession.run(configuration: captureSessionConfig)
    }
    
    func stopSession() {
        roomCaptureView.captureSession.stop()
    }
    func captureSession(
        _ session: RoomCaptureSession,
        didEndWith data: CapturedRoomData,
        error: Error?
    ) {
        if let error {
            Log("Error ending capture session; \(error)")
        }
        Task {
            finalRoom = try? await roomBuilder.capturedRoom(from: data)
        }
    }
}
