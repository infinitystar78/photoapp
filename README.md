# Photoapp
Photo app that demonstrates Vison framework and Photokit


Overview

This applacation uses SwiftUI, Vision framework and Photokit, alot of the code uses the sample code provided on the Apple developer documentation for PhotoKit.

Roughly a typical MVVM architectural pattern has been followed, with specific helper objects for specialised functons such as Vision analysis. The reasoning being that this is appropriate for the complexity and functionality of the application.


## Views
Contentview - is the mainview
PhotoItemView - is the view that supports the grid layout.
PhotoView is the main photo view that is presented when you select a photo from the grid.

## Supporting Files

### DidLoadViewmodifer 

 - to emulate viewDidLoad to load actions only once in contrast to onAppear to check permission for access to the Photo library.

### VisionSaliency 

- contains a global function to return a bounding box from the saliency analysis.

### CachedImageManager 

- is a modifed version provided by the sample code on the Apple Developer site, the main modificaiton is to return a CGImage for the saliency analysis.
The prupose of this object ois request images foir a given PHAsset.

## Models

- PhotoViewModel - drives the homescreen.
- PhotoAssetCollection and PhotoAsset - produces objects that conform to RandomAccessCollection and Identifiable to support iteration and allows the collection to be used by the ForEach view. In summary refining the data by  adding conformance to the objects so that typcial operatoins can be applied to the photo objects.
- VisionModel - Model to support saliency analaysis.
- PhotoLibrary - Object to handle permissions.


## Next steps

- Refactoring and tidying up, move the saliency method out of he PhotoView to a the VisionModel.
- Add tests, Unit test and UITests, with modfications around dependency injection and protocols so that testing can be easily performed.
- Performance analysis, test and optimise performance.
- Try to improve animations, experiment with types and duration.
- Add additional functionality using Photokit, such as editing, deleting, favouriting etc.
- Explore Saliency analysis, perhaps adding a tab for object based saliency.
- Investigate if adding the bounding box to the Image by using CALayer on a UIImage in custom, UIViewRepresentable is a better way to achieve the bouding box.
- Add video support.
- Add a message or indication when no focus / attention is detected.



