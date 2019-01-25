# RxSpriteGame
A demo project for RxSpriteKit (https://github.com/maxvol/RxSpriteGame)

A brief Carthage manual - https://medium.com/@maxim.volgin/efficient-carthage-5d7dd0a5f429

Project setup:

1. In target `Build Settings`->`Framework Search Paths` add lines:
```
$(inherited)
$(PROJECT_DIR)/Carthage/Build/iOS
```
2. In target `Build Phases`->`New Run Script Phases` add shell command `/usr/local/bin/carthage copy-frameworks` and in `Input Files` add lines:
```
$(SRCROOT)/Carthage/Build/iOS/RxSwift.framework
$(SRCROOT)/Carthage/Build/iOS/RxCocoa.framework
$(SRCROOT)/Carthage/Build/iOS/RxSpriteKit.framework
```
3. In target `General`->`Linked Frameworks and Libraries` add:
```
RxSwift.framework
RxCocoa.framework
RxSpriteKit.framework
```


