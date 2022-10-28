//
//  ContentView.swift
//  Photo App
//
//  Created by M W on 25/10/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = PhotoViewModel()
    @Environment(\.displayScale) private var displayScale

    private static let itemSpacing = 12.0
    private static let itemCornerRadius = 4.0
    private static let itemSize = CGSize(width: 90, height: 90)

    private var imageSize: CGSize {
        return CGSize(width: Self.itemSize.width * min(displayScale, 2), height: Self.itemSize.height * min(displayScale, 2))
    }

    private let columns = [
        GridItem(.adaptive(minimum: itemSize.width, maximum: itemSize.height), spacing: itemSpacing),
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: Self.itemSpacing) {
                    ForEach(model.photoAssets, id: \.self) { asset in
                        NavigationLink {
                            PhotoView(asset: asset, cache: model.cache)
                        }
                         label: {
                            photoItemView(asset: asset)
                                .buttonStyle(.borderless)
                                .accessibilityLabel(asset.accessibilityLabel)
                        }
                    }

                }.padding([.vertical], Self.itemSpacing)
            }
            .navigationTitle("Recents")
            .navigationBarTitleDisplayMode(.inline)
            .statusBar(hidden: false)
            .onLoad {
                Task {
                    await model.loadPhotos()
                }
            }
        }
    }

    private func photoItemView(asset: PhotoAsset) -> some View {
        PhotoItemView(asset: asset, cache: model.cache, imageSize: imageSize)
            .frame(width: Self.itemSize.width, height: Self.itemSize.height)
            .clipped()
            .cornerRadius(Self.itemCornerRadius)
            .onAppear {
                Task {
                    await model.cache.startCaching(for: [asset], targetSize: imageSize)
                }
            }
            .onDisappear {
                Task {
                    await model.cache.stopCaching(for: [asset], targetSize: imageSize)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
