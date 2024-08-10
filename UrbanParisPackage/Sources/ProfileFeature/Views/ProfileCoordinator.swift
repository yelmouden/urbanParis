//
//  SwiftUIView.swift
//
//
//  Created by Yassin El Mouden on 18/04/2024.
//

import DesignSystem
import FlowStacks
import PhotosUI

import SwiftUI
import Utils

public enum ProfileScreen: Equatable, Hashable {
    case myTravels(InterModuleAction<Void>)
    case selectPhotoFromCamera(Binding<UIImage?>)
    case selectPhotoFromLibrary(Binding<UIImage?>)
    case cropImage(UIImage, Binding<UIImage?>)

    public static func ==(lhs: ProfileScreen, rhs: ProfileScreen) -> Bool {
        switch (lhs, rhs) {
        case (.myTravels, .myTravels):
            return true
        case (.selectPhotoFromCamera, .selectPhotoFromCamera):
            return true
        case (.selectPhotoFromLibrary, .selectPhotoFromLibrary):
            return true
        case (.cropImage, .cropImage):
            return true
        default: return false
        }
    }

    public func hash(into hasher: inout Hasher) {
            switch self {
            case .myTravels:
                hasher.combine(1)
            case .selectPhotoFromCamera:
                hasher.combine(2)
            case .selectPhotoFromLibrary:
                hasher.combine(2)
            case .cropImage:
                hasher.combine(3)
            }
        }
}

@MainActor
public struct ProfileCoordinator: View {
    @State var routes: Routes<ProfileScreen> = []

    @State var viewModel: EditProfileViewModel
    var showMenu: Binding<Bool>?

    var getMyTravels: ((InterModuleAction<Void>) -> AnyView)?

    public init(showMenu: Binding<Bool>? = nil, getMyTravels: ((InterModuleAction<Void>) -> AnyView)? = nil) {
        self.showMenu = showMenu
        self.getMyTravels = getMyTravels
        viewModel = EditProfileViewModel()
    }

    public var body: some View {
        FlowStack($routes, withNavigation: true) {
            if let showMenu {
                EditProfileView(viewModel: viewModel)
                    .addShowMenuButton(showMenu: showMenu)
                    .flowDestination(for: ProfileScreen.self) { screen in
                        switch screen {
                        case .myTravels(let moduleAction):
                            getMyTravels?(moduleAction) ?? AnyView(EmptyView())
                        case .selectPhotoFromCamera(let binding):
                            AccessCameraView(selectedImage: binding)
                        case .selectPhotoFromLibrary(let binding):
                            ImagePicker(selectedImage: binding)
                        case .cropImage(let image, let binding):
                            ImageCropper(image: image, imageCropped: binding)
                        }
                    }
            } else {
                EditProfileView(viewModel: viewModel)
                    .flowDestination(for: ProfileScreen.self) { screen in
                        switch screen {
                        case .selectPhotoFromCamera(let binding):
                            AccessCameraView(selectedImage: binding)
                        case .selectPhotoFromLibrary(let binding):
                            ImagePicker(selectedImage: binding)
                        case .cropImage(let image, let binding):
                            ImageCropper(image: image, imageCropped: binding)
                        default:
                            EmptyView()
                        }
                    }
            }
        }
    }
}

