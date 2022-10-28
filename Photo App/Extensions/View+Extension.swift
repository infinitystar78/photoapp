//
//  View + Extension.swift
//  Photo App
//
//  Created by M W on 27/10/2022.
//

import Foundation
import SwiftUI

extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(DidLoadModifier(action: action))
    }
}
