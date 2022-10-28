//
//  VisionModel.swift
//  Photo App
//
//  Created by M W on 27/10/2022.
//

import Foundation
import SwiftUI
import Vision

class VisionModel: ObservableObject {
    
    @Published var path = Path()
    var salientObjectsPathTransform = CGAffineTransform.identity

    var observation: VNSaliencyImageObservation? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateLayersContent()
            }
        }
    }

@MainActor
    func updateLayersContent() {
        if let observation = observation {
                let cgPath = createSalientObjectsBoundingBoxPath(from: observation, transform: self.salientObjectsPathTransform)
                let path = Path(cgPath)
                self.path = path
            print("debug.36=path=\(path.boundingRect)")

        }
    }
    
    
    
}
