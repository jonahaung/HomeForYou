//
//  AppPermissionSheet.swift
//  HomeForYou
//
//  Created by Aung Ko Min on 20/5/24.
//

import SwiftUI
import XUI

struct AppPermissionOverlay<Content: View>: View {
    
    @ViewBuilder private let content: () -> Content
    @State private var appPermission: AppPermission
    
    init(_ permissionType: AppPermissionType, content: @escaping @autoclosure () -> Content) {
        _appPermission = .init(wrappedValue: .init(permissionType))
        self.content = content
    }
    
    @ViewBuilder
    var body: some View {
        switch appPermission.status {
        case .granted:
            content()
        case .notDetermined:
            VStack {
                HStack(spacing: 10.scaled) {
                    SystemImage(appPermission.permissionType.symbol, 50.scaled)
                        .symbolRenderingMode(.multicolor)
                    Text(.init(appPermission.permissionType.infoText))
                        .font(.callout)
                }
                AsyncButton {
                    appPermission.onRequest()
                } label: {
                    Text(.init(appPermission.permissionType.buttonText))
                        ._borderedProminentButtonStyle()
                }
                Text("By continue anyway, you will not be able to access most of the \(appPermission.permissionType.title) features")
                    .font(.footnote.italic())
                    .foregroundStyle(.secondary)
            }
        case .restricted:
            VStack {
                HStack(spacing: 10.scaled) {
                    SystemImage(.exclamationmarkTriangleFill, 50.scaled)
                        .symbolRenderingMode(.multicolor)
                    Text("You have restricted the \(appPermission.permissionType.title) permission. Please go to system settins and update the permission.")
                        .font(.callout)
                }
                Link(L10n_.Screen.Settings.Form.open_device_settings, destination: URL(string: UIApplication.openSettingsURLString)!)
                    ._borderedProminentButtonStyle()
            }
        }
    }
}

private struct PermissionViewModifier: ViewModifier {
    let permissionType: AppPermissionType
    func body(content: Content) -> some View {
        AppPermissionOverlay(permissionType, content: content)
    }
}
public extension View {
    func appPermissionOverlay(_ permissionType: AppPermissionType) -> some View {
        ModifiedContent(content: self, modifier: PermissionViewModifier(permissionType: permissionType))
    }
}
