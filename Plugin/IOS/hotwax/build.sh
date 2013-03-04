xcodebuild -project hotwax.xcodeproj -alltargets -sdk iphonesimulator6.0 -configuration Release
xcodebuild -project hotwax.xcodeproj -alltargets -sdk iphoneos6.0 -configuration Release
lipo build/Release-iphoneos/libhotwax.a build/Release-iphonesimulator/libhotwax.a -create -output libhotwax.a