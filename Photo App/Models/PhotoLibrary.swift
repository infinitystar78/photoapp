//
//  PhotoLibrary.swift
//  Photo App
//
//  Created by M W on 26/10/2022.
//

import Foundation
import Photos

class PhotoLibrary {
    static func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            return true
        case .notDetermined:
            return await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .restricted:
            return false
        case .denied:
            return false
        case .limited:
            return false
        @unknown default:
            return false
        }
    }
}
