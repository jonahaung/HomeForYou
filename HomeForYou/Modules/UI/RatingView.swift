//
//  RatingsView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 26/3/23.
//

import SwiftUI
import XUI

public struct RatingView: View {
    
    private let maxRating: CGFloat
    @Binding private var rating: CGFloat
    
    public init(_ rating: Binding<CGFloat>, maxRating: CGFloat = 5) {
        _rating = rating
        self.maxRating = maxRating
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<Int(rating), id: \.self) { _ in
                Image(systemName: "star.fill")
            }
            if rating != floor(rating) {
                Image(systemName: "star.leadinghalf.fill")
            }
            ForEach(0..<Int(maxRating - rating), id: \.self) { _ in
                Image(systemName: "star")
            }
        }
        .font(.title3)
        .overlay {
            GeometryReader { proxy in
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged {
                                let newRating = getRating(at: $0.location, controlSize: proxy.size)
                                if rating != newRating {
                                    rating = newRating
                                    
                                }
                            }
                    )
            }
        }
    }
    
    private func getRating(at position: CGPoint, controlSize: CGSize) -> CGFloat {
        let value = ((position.x/controlSize.width) * maxRating).halfRounded
        return min(5, max(0, value))
    }
}

// MARK: Float
private extension CGFloat {
    var halfRounded: CGFloat {
        let lowerbound = Int(self)
        let upperbound = lowerbound + 1
        let decimal: CGFloat = self - CGFloat(lowerbound)
        
        if decimal < 0.25 {
            return CGFloat(lowerbound)
        } else if decimal >= 0.25 && decimal < 0.75 {
            return CGFloat(lowerbound) + 0.5
        } else {
            return CGFloat(upperbound)
        }
    }
}
