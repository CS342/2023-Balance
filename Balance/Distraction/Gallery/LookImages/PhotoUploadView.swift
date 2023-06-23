//
//  PhotoUploadView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 23/06/2023.
//
import PhotosUI
import SwiftUI

// swiftlint:disable all
struct PhotoUploadView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State var profile = ProfileUser()
    @Binding var savedArray : [Photo]
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Upload a photo")
            }.onAppear {
                loadUser()
            }.onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        let photo = Photo(category: [imageCategoryArray[0], imageCategoryArray[6]],
                                          name: ("uploaded-" + UUID().uuidString),
                                          imageData: selectedImageData ?? Data())
                        savedArray.removeAll()
                        savedArray = UserImageCache.load(key: self.profile.id.appending("UploadedArray"))
                        let result = savedArray.filter { $0.imageData == photo.imageData }
                        if result.isEmpty {
                            savedArray.append(photo)
                            UserImageCache.save(savedArray, key: self.profile.id.appending("UploadedArray"))
                        }
                    }
                }
            }
        
//        if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
////            Image(uiImage: uiImage)
////                .resizable()
////                .scaledToFit()
////                .frame(width: 250, height: 250)
//        }
    }
    
    func loadUser() {
        UserProfileRepositoryToLocal.shared.fetchCurrentProfile { profileUser, error in
            if let error = error {
                print("Error while fetching the user profile: \(error)")
                return
            } else {
                print("User: " + (profileUser?.description() ?? "-"))
                self.profile = profileUser ?? ProfileUser()
            }
        }
    }
}
