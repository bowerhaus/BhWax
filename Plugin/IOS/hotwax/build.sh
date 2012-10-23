xcodebuild -project hotwax.xcodeproj -alltargets -sdk iphonesimulator5.1 -configuration Release
xcodebuild -project hotwax.xcodeproj -alltargets -sdk iphoneos5.1 -configuration Release
lipo build/Release-iphoneos/libhotwax.a build/Release-iphonesimulator/libhotwax.a -create -output libhotwax.a