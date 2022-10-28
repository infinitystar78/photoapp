import CoreGraphics
import Photos
import SwiftUI
import Vision

struct PhotoView: View {
    var asset: PhotoAsset
    var cache: CachedImageManager?
    @State private var image: Image?
    @State private var cgImage: CGImage?
    @State private var imageRequestID: PHImageRequestID?
    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)
    @State var aspectFill = false
    @StateObject var visionModel = VisionModel()

    var body: some View {
        Group {
            if let image = image {
                ZStack {
                    image
                        .resizable()
                        .aspectRatio(contentMode: aspectFill ? .fill : .fit)
                        .accessibilityLabel(asset.accessibilityLabel)
                        .overlay(GeometryReader { geometry in
                            Rectangle()
                                .path(in: CGRect(x: visionModel.path.boundingRect.minX * geometry.size.width,
                                                 y: visionModel.path.boundingRect.minY * geometry.size.height,
                                                 width: visionModel.path.boundingRect.width * geometry.size.width,
                                                 height: visionModel.path.boundingRect.height * geometry.size.height))
                                .stroke(Color.yellow, lineWidth: 3.0)
                        }
                        )
                }

            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.black)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    self.dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.white)

                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.easeIn(duration: 0.4)) {
                        aspectFill.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                        .foregroundColor(Color.white)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)

        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                        self.cgImage = result.cgImage
                        saliancyAnalysis()
                    }
                }
            }
        }
    }

    func saliancyAnalysis() {
        guard let cgImage = cgImage else {
            return
        }

        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                        orientation: .up,
                                                        options: [:])
        let request = VNGenerateAttentionBasedSaliencyImageRequest()
        try? imageRequestHandler.perform([request])
        guard
            let results = request.results,
            let result = results.first

        else {
            return
        }
        visionModel.observation = result
    }
}
