//
//  LocationPreviewLookAroundView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 24/3/24.
//

import MapKit
import SwiftUI
import XUI

struct LocationPreviewLookAroundView: View {
    
    var lookAroundScene: MKLookAroundScene
    
    var body: some View {
        VStack {
            LookAroundPreview(initialScene: lookAroundScene)
        }
        .ignoresSafeArea(.all)
    }
}
