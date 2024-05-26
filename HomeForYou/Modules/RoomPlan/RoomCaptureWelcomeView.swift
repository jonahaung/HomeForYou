//
//  WelcomeView.swift
//  RoomPlan 2D
//
//  Created by Dennis van Oosten on 24/02/2023.
//

import SwiftUI

struct RoomCaptureWelcomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "house")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding(.bottom, 8)

            Text("RoomPlan 2D")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(.bold)
            Text("Scan your room and create a 2D floor plan.")

            Spacer()
                .frame(height: 50)

            NavigationLink("Start Scanning") {
                RoomCaptureScanView()
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .fontWeight(.bold)
        }
        .embeddedInNavigationView()
    }
}
