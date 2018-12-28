# Deliveries Demo

A demo iOS app showing a list of delivery items & its location on a map view

![Preview](https://github.com/denniszxxc/deliveries_demo/blob/master/preview_deliveries.gif)

## Getting Started

### Running the project
- run `carthage bootstrap --platform iOS` to build libraries using [Carthage](https://github.com/Carthage/Carthage)
- Open `deliveries.xcodeproj` using Xcode 10.1+ 
- (optional) Change the signing setting if needed
- Click 'Product' -> 'Run'

### Running the test
- run `carthage bootstrap --platform iOS` to build libraries
- Open `deliveries.xcodeproj` using Xcode 10.1+ 
- Click 'Product' -> 'Test'

## Technical Details
- Swift version: 4.2
### Libraries used
- [Realm Database](https://github.com/realm/realm-cocoa): Data persistence
- [RxSwift](https://github.com/ReactiveX/RxSwift): Reactive Programming
- [RxRealm](https://github.com/RxSwiftCommunity/RxRealm): RxSwift extension for Realm
- [Kingfisher](https://github.com/onevcat/Kingfisher): Image Downloading & caching
- [Pulley](https://github.com/52inc/Pulley/): Bottom Card Drawer
#### Development dependency 
- [SwiftLint](https://github.com/realm/SwiftLint) for enforcing Swift style

## License 
