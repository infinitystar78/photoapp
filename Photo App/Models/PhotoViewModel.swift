//
//  PhotoFetchService.swift
//  Photo App
//
//  Created by M W on 26/10/2022.
//

import AVFoundation
import Foundation
import Photos

class PhotoViewModel: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
 
   private var allPhotos = PHFetchResult<PHAsset>()
    @Published var photoAssets: PhotoAssetCollection =
        PhotoAssetCollection(PHFetchResult<PHAsset>())
    let cache = CachedImageManager()

    // load photos
    func loadPhotos() async {
        let authorized = await PhotoLibrary.checkAuthorization()
        guard authorized else {
            print("Not Authorrized")
            return
        }
        PHPhotoLibrary.shared().register(self)
        await retrievePhotos()
    }
    //protocol requirement
    func photoLibraryDidChange(_ changeInstance: PHChange) {}
   
    @MainActor
    func retrievePhotos() {
        // 1
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false),
        ]
        allPhotosOptions.fetchLimit = 1000
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        photoAssets = PhotoAssetCollection(allPhotos)

    }

    // deinit registration
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    
    
    
    
    
    
    
    
}
