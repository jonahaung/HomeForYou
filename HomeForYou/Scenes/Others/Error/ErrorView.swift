//
//  ErrorView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 23/3/23.
//

import SwiftUI

struct ErrorView: View {

    let error: Error
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
            Button(action: retryAction, label: { Text("Retry").bold() })
        }
        .padding()
    }
}
