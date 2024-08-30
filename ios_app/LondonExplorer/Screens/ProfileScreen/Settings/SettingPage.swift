//
//  SettingPage.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 27.08.2024.
//

import Foundation
import SwiftUI

struct SettingPage: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var globalSettings: GlobalSettings
    @FocusState var isFocused
    
    @State var setting: SettingsType
    @State var text: String = ""
    @State var isSaving: Bool = false
    @State var error: Bool = false
    @State var errorText: String = ""
    
    @State var newImage: UIImage?
    @State var isShowingImagePicker = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 25) {
                HStack {
                    ScreenHeader(headline: .constant("Settings"))
                    Spacer()
                }
                
                if setting == .picture {
                    imageUpdate
                } else {
                    CustomTextField(
                        fieldText: .constant(setting.description),
                        fillerText: .constant(setting.description),
                        textVariable: $text,
                        height: setting == .description ? 300 : 80,
                        maxLength: setting.limit
                    )
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                ButtonView(
                    text: .constant("Save"),
                    colour: Color.blueAccent,
                    textColour: Color.white,
                    size: .L,
                    disabled: Binding(
                        get: {
                            newImage == nil && text.isEmpty
                        },
                        set: { _ in }
                    ),
                    isLoading: $isSaving,
                    action: self.saveChanges
                )
                .padding(.bottom, 15)
            }
        }
        .padding()
        .error(text: errorText, isPresented: $error)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $newImage)
        }
        .onAppear(perform: self.initialScreenSetup)
    }
    
    private var imageUpdate: some View {
        VStack(spacing: 15) {
            ZStack {
                if let newImage = newImage {
                    Image(uiImage: newImage)
                        .profilePicture(size: 150)
                } else {
                    LoadingUserImage(userImage: $auth.profile.imageName, imageSize: 150)
                }
                
                Color.black.opacity(0.2)
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .foregroundColor(Color.white).opacity(0.3)
            }
            .frame(width: 150, height: 150)
            .cornerRadius(100)
            
            Text(setting.description)
                .font(.system(size: 14, weight: .bold))
                .kerning(-0.2)
        }
        .onTapGesture {
            self.isShowingImagePicker = true
        }
    }
    
    private func initialScreenSetup() {
        switch setting {
        case .picture:
            break
        case .name:
            self.text = auth.profile.name
        case .username:
            self.text = auth.profile.userName
        case .description:
            self.text = auth.profile.description ?? ""
        }
        self.isFocused = true
    }
    
    private func saveChanges() {
        isSaving = true
        Task {
            do {
                if self.setting == .picture, let image = newImage {
                    let imageName = try await ImagesRepository.shared.uploadImage(userId: auth.profile.id, image: image)
                    self.text = imageName ?? ""
                }
                try await auth.editProfile(setting: setting, newValue: text)
                globalSettings.setProfileReloadTrigger(to: true)
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                self.error = true
                self.errorText = error.localizedDescription
            }
            isSaving = false
        }
    }
}

#Preview {
    SettingPage(setting: .picture)
        .environmentObject(AuthController(testProfile: true))
        .environmentObject(GlobalSettings())
}
