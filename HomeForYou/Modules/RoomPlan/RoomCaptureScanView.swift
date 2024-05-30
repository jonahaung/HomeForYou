//
//  RoomCaptureView.swift
//  RoomPlan 2D
//
//  Created by Dennis van Oosten on 24/02/2023.
//

import SwiftUI
import _SpriteKit_SwiftUI
import XUI

struct RoomCaptureScanView: View {
    private let model = RoomCaptureModel.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isScanning = false
    @State private var isShowingFloorPlan = false
    
    var body: some View {
        ZStack {
            RoomCaptureRepresentable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Button {
                        model.stopSession()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    } label: {
                        Text("Cancel")
                    }
                    Spacer()
                    Button {
                        if isScanning {
                            stopSession()
                        } else {
                            isShowingFloorPlan = true
                        }
                    } label: {
                        Text(isScanning ? "Done" : "View 2D floor plan")
                    }
                }
                .padding()
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startSession()
        }
        .sheet(isPresented: $isShowingFloorPlan) {
            if let finalRoom = model.finalRoom {
                SpriteView(scene: FloorPlanScene(capturedRoom: finalRoom))
                    .ignoresSafeArea()
            }
        }
    }
    
    private func startSession() {
        isScanning = true
        model.startSession()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func stopSession() {
        isScanning = false
        model.stopSession()
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
