//
//  AddressResult.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 6/2/23.
//

import SwiftUI
import MapKit
import XUI
import SFSafeSymbols

struct MapSnapshotView: View {
    
    let location: GeoLocation
    var span: CLLocationDegrees = 0.01
    @Injected(\.ui) private var ui
    
    @State private var snapshotImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = snapshotImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    LinkButton(.appleMap(lattitude: location.latitude, longitude: location.longitude)) {
                        SystemImage(.circlebadgeFill)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .buttonStyle(.plain)
                } else {
                    Color.secondary
                    ProgressView()
                        .task {
                            await generateSnapshot(width: geometry.size.width, height: geometry.size.height)
                        }
                }
            }
            ._flexible(.all)
            .equatable(by: snapshotImage)
        }
    }
    
    private func generateSnapshot(width: CGFloat, height: CGFloat) async {
        let rect = CGRect(origin: .zero, size: .init(width: width, height: height))
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = CGSize(width: width, height: height)
        options.showsBuildings = true
        options.mapType = .standard
        options.scale = await UIScreen.main.scale
        options.traitCollection = .init(userInterfaceStyle: .light)
        let snapshotter = MKMapSnapshotter(options: options)
        do {
            let snapshot = try await snapshotter.start()
            let image = UIGraphicsImageRenderer(size: options.size).image { _ in
                snapshot.image.draw(at: .zero)
                
                let pinView = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: nil)
                let pinImage = pinView.image

                
                var point = snapshot.point(for: location.coordinate)
                
                if rect.contains(point) {
                    point.x -= pinView.bounds.width / 2
                    point.y -= pinView.bounds.height / 2
                    point.x += pinView.centerOffset.x
                    point.y += pinView.centerOffset.y
                    pinImage?.draw(at: point)
                }
            }
            await MainActor.run {
                snapshotImage = image
            }
        } catch {
            print(error)
        }
    }
}
