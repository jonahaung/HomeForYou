//
//  LottieView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 10/7/23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    private let lottieFile: String
    private let animationView = LottieAnimationView()
    private let contentMode: UIView.ContentMode
    private let loopMode: LottieLoopMode
    private let isJson: Bool

    init(lottieFile: String, isJson: Bool = true, loopMode: LottieLoopMode = .loop, contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.lottieFile = lottieFile
        self.loopMode = loopMode
        self.contentMode = contentMode
        self.isJson = isJson
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()

        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            animationView.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor),
            animationView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor)
        ])

        if isJson {
            animate()
        } else {
            animateLottie()
        }
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    private func animate() {
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = contentMode
        animationView.maskAnimationToBounds = true
        animationView.play()
    }

    private func animateLottie() {
        DotLottieFile.named(lottieFile) { result in
            guard case Result.success(let lottie) = result else { return }
            animationView.loadAnimation(from: lottie)
            animationView.loopMode = loopMode
            animationView.backgroundBehavior = .pauseAndRestore
            animationView.contentMode = contentMode
            animationView.maskAnimationToBounds = true
            animationView.play()
        }
    }
}
