//
//  AttachmentPostForm.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 21/7/23.
//

import SwiftUI
import XUI
import AVKit

struct PostForm_Attachmments: View {
    
    @EnvironmentObject private var post: Post
    @State private var attachments = [XAttachment]()
    @State private var selections = [XAttachment]()
    @State private var tapped: XAttachment?
    @State private var editing = false
    @Environment(PostingFlowRouter.self) private var router
    @Injected(\.ui) private var ui
    
    @MainActor
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Section {
                WaterfallVList(columns: calculateNoOfColumns(), spacing: 3) {
                    ReorderableForEach($attachments, allowReordering: .constant(true)) { item, isDragged in
                        ZStack(alignment: .topTrailing) {
                            if item.type == .photo {
                                WaterfallImage(urlString: item.url)
                            } else if item.type == .video, let url = item._url {
                                VideoPlayer(player: AVPlayer(url: url))
                                    .frame(minHeight: 150)
                            }
                            if editing {
                                SystemImage(isSelected(for: item) ? .checkmarkCircleFill : .circle)
                                    .foregroundColor(.white)
                            }
                        }
                        .opacity(isDragged ? 0.3 : 1)
                        .onTapGesture {
                            if editing {
                                toggleSelected(for: item)
                            } else {
                                tapped = item
                            }
                        }
                    }
                }
            } header: {
                Text("Add photos, videos or RoomPlan 3D data")
            }
            Section {
                Spacer(minLength: 100)
            } footer: {
                VStack {
                    Text("\(Image(systemSymbol: .photoStack)) Select from Photo Library")
                        ._borderedProminentLightButtonStyle()
                        ._presentFullScreen {
                            _PhotoPicker(attachments: $attachments, multipleSelection: true)
                                .selectionLimit(Constansts.Posting.Number_Of_Max_Attachments_Allowed)
                                .edgesIgnoringSafeArea(.all)
                        }
                        ._hidable(attachments.count >= Constansts.Posting.Number_Of_Max_Attachments_Allowed)
                    HStack {
                        Text("Capture \(Image(systemSymbol: .rotate3d)) RoomPlan 3D")
                            ._presentFullScreen {
                                RoomCaptureWelcomeView()
                                    .ignoresSafeArea()
                                    .statusBarHidden()
                            }
                        
                        if let url = post._roomURL {
                            ShareLink(item: url) {
                                SystemImage(.checkmarkCircleFill)
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(.borderless)
                        }
                    }._borderedProminentLightButtonStyle()
                }
            }
        }
        .safeAreaPadding(4)
        .animation(.default, value: editing)
        .animation(.interactiveSpring(), value: selections)
        .scrollContentBackground(.hidden)
        .background(ui.colors.systemGroupedBackground)
        .navigationTitle("@attachments")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    editing.toggle()
                } label: {
                    Text(editing ? "Done" : "Edit")
                }
                .disabled(attachments.isEmpty)
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                bottomBar
            }
        }
        .fullScreenCover(item: $tapped) { tapped in
            switch tapped.type {
            case .photo:
                PhotoGalleryView(attachments: attachments, title: post.category.title, selection: .init(get: {
                    attachments.firstIndex(of: tapped) ?? 0
                }, set: { _ in }))
            case .video:
                if let url = tapped._url {
                    MediaPlayerView(url: url)
                        .embeddedInNavigationView()
                }
            }
        }
        .synchronizeLazily($post.attachments, $attachments)
        .appPermissionOverlay(.mediaLibrary)
    }
    
    @ViewBuilder
    private var bottomBar: some View {
        if editing {
            if attachments.count != selections.count {
                Button {
                    
                    selections = attachments
                } label: {
                    Text("Select All")
                }
            } else {
                Button {
                    selections.removeAll()
                } label: {
                    Text("Un Select All")
                }
            }
            
            Spacer()
            Button {
                selections.forEach { each in
                    if let i = attachments.firstIndex(of: each) {
                        attachments.remove(at: i)
                        if let s = selections.firstIndex(of: each) {
                            selections.remove(at: s)
                        }
                    }
                }
                post.roomURL = nil
                editing = false
            } label: {
                SystemImage(.trash)
            }
            .accentColor(.red)
            .disabled(selections.isEmpty)
        } else {
            Spacer()
            Button {
                router.path.append(.details)
            } label: {
                Text("next \(Image(systemSymbol: .arrowshapeForwardFill))")
            }
            .disabled(attachments.isEmpty)
        }
    }
}

extension PostForm_Attachmments {
    private func calculateNoOfColumns() -> Int {
        let count = attachments.count
        guard count > 0 else { return 1 }
        return editing ? 3 : 2
    }
    private func isSelected(for item: XAttachment) -> Bool {
        selections.contains(item)
    }
    private func toggleSelected(for item: XAttachment) {
        if let i = selections.firstIndex(of: item) {
            selections.remove(at: i)
        } else {
            selections.append(item)
        }
    }
}
