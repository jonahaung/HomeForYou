//
//  MRTMapView.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 7/6/24.
//

import SwiftUI
import MapKit
import XUI

struct MRTMapView: View {
    
    typealias Line = (MRTLine, [MRT])
    
    @State var selection: MRT?
    @State var selectedLine: MRTLine?
    var onSelect: @Sendable (MRT) async -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition = .automatic
    @State private var searchText = ""
    @State private var animation: MapKeyFrameAnimation = .init()
    @FocusState private var isSearching: Bool
    
    private let data: [Line] = {
        var items = [Line]()
        MRTLine.allCases.forEach { each in
            items.append((each, each.mrts))
        }
        return items
    }()
    
    var body: some View {
        Map(position: $position, selection: $selection) {
            if isSearching {
                if searchText.isWhitespace {
                    ForEach(data, id: \.0) { (line, mrts) in
                        MapPolyline(coordinates: mrts.map{ $0.coordinate }, contourStyle: .geodesic)
                            .stroke(line.color.gradient, lineWidth: 3)
                    }
                } else {
                    ForEach(data, id: \.0) { (line, mrts) in
                        ForEach(mrts.filter{ $0.name.contains(searchText, caseSensitive: false) }) { mrt in
                            if let mainSymbol = mrt.mainSymbol(for: line) {
                                ForEach(mrt.symbol) { symbol in
                                    if symbol.code != mainSymbol.code {
                                        Annotation.init(symbol.code, coordinate: mrt.coordinate) {
                                            SystemImage(.circlebadgeFill)
                                                .foregroundStyle(symbol.swiftColor.gradient)
                                        }
                                    }
                                }
                                Marker(mrt.name, monogram: Text("\(mainSymbol.code)"), coordinate: mrt.coordinate)
                                    .tint(mainSymbol.swiftColor.gradient)
                                    .tag(mrt)
                            }
                        }
                    }
                }
            } else {
                if let line = selectedLine, let results = data.first(where: { $0.0 == selectedLine })?.1 {
                    MapPolyline(coordinates: results.map{ $0.coordinate }, contourStyle: .geodesic)
                        .stroke(line.color, lineWidth: 2)
                    
                    ForEach(results) { mrt in
                        if let mainSymbol = mrt.mainSymbol(for: line) {
                            ForEach(mrt.symbol) { symbol in
                                if symbol.code != mainSymbol.code {
                                    Annotation.init(symbol.code, coordinate: mrt.coordinate) {
                                        SystemImage(.circlebadgeFill)
                                            .foregroundStyle(symbol.swiftColor.gradient)
                                    }
                                }
                            }
                            Marker(mrt.name, monogram: Text("\(mainSymbol.code)"), coordinate: mrt.coordinate)
                                .tint(mainSymbol.swiftColor.gradient)
                                .tag(mrt)
                        }
                    }
                } else {
                    ForEach(data, id: \.0) { (line, mrts) in
                        ForEach(mrts) { mrt in
                            if let mainSymbol = mrt.mainSymbol(for: line) {
                                ForEach(mrt.symbol) { symbol in
                                    if symbol.code != mainSymbol.code {
                                        Annotation.init(symbol.code, coordinate: mrt.coordinate) {
                                            SystemImage(.circlebadgeFill)
                                                .foregroundStyle(symbol.swiftColor.gradient)
                                        }
                                    }
                                }
                                Marker(mrt.name, monogram: Text("\(mainSymbol.code)"), coordinate: mrt.coordinate)
                                    .tint(mainSymbol.swiftColor.gradient)
                                    .tag(mrt)
                            }
                        }
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .flat, emphasis: .muted, pointsOfInterest: .excludingAll, showsTraffic: false))
        .mapControls {
            MapCompass()
            MapScaleView()
        }
        .mapControlVisibility(.visible)
        .mapCameraKeyframeAnimator(trigger: animation, keyframes: { camera in
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(animation.coordinate ?? camera.centerCoordinate, duration: 1)
            }
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(animation.distance ?? camera.distance, duration: 1)
            }
            KeyframeTrack(\MapCamera.pitch) {
                LinearKeyframe(animation.pitch ?? camera.pitch, duration: 3)
            }
        })
        .ignoresSafeArea(edges: .bottom)
        .safeAreaInset(edge: .top) {
            VStack {
                HStack {
                    _DismissButton(isProtected: selection != nil, title: "Cancel")
                        ._overlayLightButtonStyle()
                    Spacer()
                }
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                HStack(alignment: .bottom) {
                    if selection != nil {
                        Button.init {
                            selection = nil
                        } label: {
                            SystemImage(.trashFill)
                                .symbolRenderingMode(.multicolor)
                                ._overlayLightButtonStyle()
                        }
                    }
                    if let selectedLine {
                        Text(selectedLine.name)
                            .bold()
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        ForEach(data, id: \.0) { (line, mrts) in
                            Button {
                                onSelectLine(line)
                            } label: {
                                Circle().fill(line.color.gradient)
                                    .frame(square: line == selectedLine ? 50 : 30)
                            }
                        }
                    }
                    .animation(.interactiveSpring, value: selectedLine)
                }
                
                HStack {
                    if let selection {
                        AsyncButton {
                            await onSelect(selection)
                            try await Task.sleep(seconds: 1)
                            dismiss()
                        } label: {
                            Text("Apply")
                                ._borderedProminentLightButtonStyle()
                        }
                    } else {
                        TextField("Search stations by name", text: $searchText)
                            .focused($isSearching)
                            .padding(.leading)
                            .padding(.vertical, 8)
                            .background(.bar, in: Capsule())
                        if isSearching {
                            Button {
                                searchText = ""
                                isSearching = false
                            } label: {
                                Text(searchText.isWhitespace ? "Cancel" : "Clear")
                                    ._overlayLightButtonStyle()
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onChange(of: selection, initial: false, {
            if let selection {
                animation = .init(selection.coordinate, distance: 3000, pitch: 75)
            } else {
                let results = selectedLine == nil ? MRT.allValues : data.first(where: { $0.0 == selectedLine })?.1 ?? []
                let coordinate = PolygonRegion(verticies: results.map{ $0.coordinate}).center
                animation = .init(coordinate, distance: 181000)
            }
        })
        .onChange(of: isSearching) { _, new in
            animation.distance = new ? 140000 : 70000
        }
        ._onAppear(after: 1) {
            animation.distance = 160000
        }
    }
    
    private func onSelectLine(_ line: MRTLine?) {
        isSearching = false
        _Haptics.play(.light)
        selection = nil
        selectedLine = line == selectedLine ? nil : line
        let results = selectedLine == nil ? MRT.allValues : data.first(where: { $0.0 == selectedLine })?.1 ?? []
        animation.coordinate = PolygonRegion(verticies: results.map{ $0.coordinate}).center
    }
}
