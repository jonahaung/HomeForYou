//
//  ImageResizer.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/6/24.
//

import Foundation
import CoreImage

public protocol ImageResizer {
    func resize(from image: CGImage, quality: ImageQuality) -> CGImage?
}
