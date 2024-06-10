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
    
    var onSelect: @Sendable (MRT) async -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition = .automatic
    @State private var selection: MRT?
    @State private var selectedLine: MRTLine?
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
                        MapPolyline(coordinates: mrts.map{ $0.coordinate }, contourStyle: .straight)
                            .stroke(line.color, lineWidth: 3)
                    }
                } else {
                    ForEach(data, id: \.0) { (line, mrts) in
                        let filtered = mrts.filter{ $0.name.contains(searchText, caseSensitive: false) }
                        ForEach(filtered) { each in
                            let symbols = each.symbol
                            if symbols.count == 1 {
                                let symbol = each.mainSymbol(for: line.rawValue)
                                Marker(each.name, monogram: Text("\(symbol.code)"), coordinate: each.coordinate)
                                    .tint(symbol.swiftColor)
                                    .tag(each)
                            } else {
                                ForEach(symbols) { symbol in
                                    if symbols.first == symbol {
                                        Marker(each.name, monogram: Text("\(symbol.code)"), coordinate: each.coordinate)
                                            .tint(symbol.swiftColor)
                                            .tag(each)
                                    } else {
                                        Marker(each.name, monogram: Text("\(symbol.code)"), coordinate: each.coordinate)
                                            .tint(symbol.swiftColor)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if let selectedLine {
                    let results = data.first(where: { $0.0 == selectedLine })?.1 ?? []
                    
                    MapPolyline(coordinates: results.map{ $0.coordinate }, contourStyle: .straight)
                        .stroke(selectedLine.color.gradient, lineWidth: 2)
                    
                    ForEach(results) { each in
                        let symbol = each.mainSymbol(for: selectedLine.rawValue)
                        Marker(each.name, monogram: Text("\(symbol.code)"), coordinate: each.coordinate)
                            .tint(symbol.swiftColor.gradient)
                            .tag(each)
                    }
                } else {
                    ForEach(data, id: \.0) { (line, mrts) in
                        MapPolyline(coordinates: mrts.map{ $0.coordinate }, contourStyle: .straight)
                            .stroke(line.color.gradient, lineWidth: 2)
                        ForEach(mrts) { each in
                            let symbol = each.mainSymbol(for: line.rawValue)
                            Marker(each.name, monogram: Text("\(symbol.code)"), coordinate: each.coordinate)
                                .tint(symbol.swiftColor.gradient)
                                .tag(each)
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
        .mapCameraKeyframeAnimator(trigger: animation, keyframes: { camera in
            KeyframeTrack(\MapCamera.centerCoordinate) {
                LinearKeyframe(animation.coordinate ?? camera.centerCoordinate, duration: 1)
            }
            KeyframeTrack(\MapCamera.distance) {
                LinearKeyframe(animation.distance, duration: 1)
            }
            KeyframeTrack(\MapCamera.pitch) {
                LinearKeyframe(animation.pitch, duration: 3)
            }
        })
        .ignoresSafeArea(edges: .vertical)
        .safeAreaInset(edge: .top) {
            VStack {
                HStack {
                    _DismissButton(isProtected: selection != nil, title: "Cancel")
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
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onChange(of: selection, initial: false, {
            if let selection {
                animation = .init(coordinate: selection.coordinate, distance: 3000, pitch: 75)
            } else {
                let results = selectedLine == nil ? MRT.allValues : data.first(where: { $0.0 == selectedLine })?.1 ?? []
                let coordinate = PolygonRegion(verticies: results.map{ $0.coordinate}).center
                animation = .init(coordinate: coordinate, distance: 70000, pitch: 0)
            }
        })
        .onChange(of: isSearching) { _, new in
            animation.distance = new ? 100000 : 70000
        }
        ._onAppear(after: 1) {
            animation.distance = 70000
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
