//
//  ViewModifiers.swift
//  Photo App
//
//  Created by M W on 27/10/2022.
//

import Foundation
import SwiftUI
//modifier to perform action once, to emulate somthing like ViewDidLoad
struct DidLoadModifier: ViewModifier {
    @State private var didLoad = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if didLoad == false {
                    didLoad = true
                    action?()
                }
            }
    }
}
