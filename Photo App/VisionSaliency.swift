//
//  VisionSaliency.swift
//  Photo App
//
//  Created by M W on 27/10/2022.
//

import Foundation
import Vision

public func createSalientObjectsBoundingBoxPath(from observation: VNSaliencyImageObservation, transform: CGAffineTransform) -> CGPath {
    let path = CGMutablePath()
    if let salientObjects = observation.salientObjects {
        for object in salientObjects {
            let bbox = object.boundingBox
            path.addRect(bbox, transform: transform)
        }
    }
    return path
}


