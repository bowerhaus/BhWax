
Hot Wax for Gideros 
===================

[Wax](https://github.com/probablycorey/wax) is a Lua <-> Objective C bridge by [Corey Johnson](https://github.com/probablycorey).
This module is a plugin for [Gideros SDK](http://giderosmobile.com) that allows Wax to be
used in Gideros apps. I've chosen to call this [Hot Wax] or *BhWax*. Some small changes have to be made to Corey's
original Wax code so you are required to pull down a modified repository for this from my GitHub, called
[CoreyJohnsonWax](https://github.com/bowerhaus/CoreyJohnsonWax.git).

The plugin also contains some new enhancements to allow Wax to play nicely with the (relatively)
new blocks feature of Objective C. You can read more about BhWax, including instructions on how
to build the plugin, in [my blog entry](http://bowerhaus.eu/blog/files/hot_wax.html).

This library also features a collection of demonstrations of the [Hot Wax] interface as listed below.
You will also need one additional ObjectiveC file (UIImage+Save.m) to be included in the plugin,
which contains a protocol extension to allow [UIImage] objects to resize and save themselves (this is only required
for the image picker demo in [BhWaxDemo.lua]).
 
#### Lua Modules 
 
 - [BhWaxDemo.lua] - Example that displays an image picker, a [UITextView] and a YouTube video.
 - [BhWaxPhysicsDemo.lua] - Example showing Box2d physics interfacing with [UIView]s.
 - [BhWaxAutoComplete.lua] - Utility to generate Gideros API information for the Cocoa libraries.
  
 The following utility modules may be useful in other projects:
 
 - [IosImagePicker.lua]  - Class to bring up an iOS image/photo picker dialog. 
 - [BhUIViewFrame.lua]	- Class to wrap UIViews so the can interact with the Gideros scene hierarchy.
 
 To run a particular demo, comment in **one** of the following lines in *main.lua*:
 
     BhWaxDemo.new()
     BhWaxPhysicsDemo.new()
     BhAutoComplete.new()
	 

Folder Structure
================

This module is part of the general Bowerhaus library for Gideros mobile. There are a number of cooperating modules in this library, each with it's own Git repository. In order that the example project files will run correctly "out of the box" you should create an appropriate directory structure and clone/copy the files within it.

#####/MyDocs
Place your own projects in folder below here

#####/MyDocs/Library
Folder for library modules

#####/MyDocs/Library/Bowerhaus
Folder containing sub-folders for all Bowerhaus libraries

#####/MyDocs/Library/Bowerhaus/BhHelpers
Folder for helper/utility functions. You will NEED THIS MODULE.

#####/MyDocs/Library/Bowerhaus/BhWax
Folder for THIS MODULE

#####/MyDocs/Library/CoreyJohnsonWax
Folder for MODIFIED VERSION OF WAX
	 
[UITextView]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UITextView_Class/Reference/UITextView.html
[UIView]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIView_Class/UIView/UIView.html
 

# BhWaxDemo.lua
 
A quick demonstration of the [Hot Wax] Lua-ObjectiveC bridge as tuned for Gideros SDK. 

KUDOS TO [COREY JOHNSON](https://github.com/probablycorey). This Wax stuff is truly magic!

Because of the nature of ObjectiveC, this demonstration is **ONLY FOR IOS**.

In this demo we bring up a native IOS ImagePicker and allow the user to choose a photo from the photo
library. Once an image is picked, it is resized and saved to our documents directory from where it
is loaded as a standard Gideros Bitmap. You are then given the opportunity to write a title for the
photo using an IOS multiline UITextView. After that, if you click on the YouTube logo, you'll see a 
video showing how to get started with Wax and Gideros.

*Please note, for this example to work, you will need to build your Gideros player with one
additional ObjectiveC file (UIImage+Save.m), which
contains a protocol extension to allow [UIImage] objects to resize and save themselves.*

[Hot Wax]: http://bowerhaus.eu/blog/files/hot_wax.html
[UIImage]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIImage_Class/Reference/Reference.html
 

# BhWaxPhysicsDemo.lua

The intention behind this demonstration is to show how [UIView]s created using [Hot Wax] can be manipulated in much the same
way as the other Gideros display objects such as [Sprite]s. 

As the screen is touched, this demo creates a new
editable [UITextView] populated with some default text. Each text view is under control of the Box2d physics engine and
can be seen to fall with gravity, whilst also colliding with other views previously created. The gravity force
can be altered by tilting the device and each [UITextView] can be edited while it is "falling".

[Hot Wax]: http://bowerhaus.eu/blog/files/hot_wax.html
[UITextView]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UITextView_Class/Reference/UITextView.html
[UIView]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIView_Class/UIView/UIView.html 

 
# BhWaxAutoComplete.lua

Hot Wax allows you to write Cocoa code directly in Lua, inside the Gideros IDE. However, the ObjectiveC method selectors
are often quite long and difficult to remember. 

This demo will walk the Cocoa class object tree and generate an autocompletion file of all the class and instance
methods for the classes that you specify. This autocompletion file, "cocoa_annot.txt", can be appended to the 
"gideros_annot.api" file which is to be found in the "Gideros Studio/Contents/Resources" folder. Note that you
will have to use "Show Package Contents" to drill into the Gideros Studio applicatuion to find this location.

You must restart Gideros Studio after updating this file in order to see the new autocompletion annotations working.
 

# IosImagePicker.lua 

This is a [Hot Wax] class to bring up the standard IOS ImagePicker. We get a callback to a supplied handler
function if an image is picked successfully. The handler is passed the real ObjectiveC
[UIImage] object to do with what we will.

This code is almost a drop-in replacement for the plugin code that I wrote in *BhImagePicker.mm*
(see [here](http://bowerhaus.eu/blog/files/gideros_snapshot.html)). However, that code is more complex to
understand (IMO), needs to be careful with memory management and has 432 lines compared with 130 or so.
Seems like a hands down win for Hot Wax to me.

[Hot Wax]: http://bowerhaus.eu/blog/files/hot_wax.html
[UIImage]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIImage_Class/Reference/Reference.html


## Class IosImagePicker [IosImagePicker]

[IosImagePicker] is a Wax Class that brings up an iOS ImagePicker dialog to allow the user to choose an image from the
device camera or photo library. The picked image will be passed to a callback handler function as an [UIImage] object.

### function IosImagePicker:pickImage(sourceType, handlerFunc, handlerTarget) [IosImagePicker:pickImage]
Bring up an image picker based on what sort of device we are running on. We are passed a callback handler function to use when an image is chosen by the user.

- **sourceType** 	- an integer describing the device location where the image should be picked
					from. Can be one of the *UIImagePickerControllerSourceType* enum values. 
					Hence, *UIImagePickerControllerSourceTypePhotoLibrary*, *UIImagePickerControllerSourceTypeCamera*, *UIImagePickerControllerSourceTypeSavedPhotosAlbum* are valid options.   
- **handlerFunc** 	- the function that will be called when an image has been picked. The picked image is passed as an [UIImage] parameter.   
- **handlerTarget** 	- (optional) target object of the handler function if it is an instance method.

##### Typical usage:

     local picker=IosImagePicker:init()
     picker:pickImage(UIImagePickerControllerSourceTypePhotoLibrary, self.onImagePicked, self) 

     function MyClass:onImagePicked(uiImage)		
  	    uiImage:savePNG("|D|pickedImage.png")
     end


# BhUIViewFrame.lua

Implements [BhUIViewFrame]; a useful wrapper around Wax [UIView]s that allow them to be manipulated in 
much the same way as Gideros [Sprite]s.

[UIView]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIView_Class/UIView/UIView.html
  

## Class BhUIViewFrame[BhUIViewFrame]

A [BhUIViewFrame] may be placed in the normal Gideros display hierarchy and can be moved
around with tweening or physics. The [UIView] associated with this frame will be automatically matched up in terms of
position, size, rotation, visibility and also alpha. 

Note that this uses an **ENTER_FRAME** handler to apply the transformations and each of these many involve several Wax calls.
Hence, even though we try to minimise the effort when nothing has been changed, you should be aware that animating many 
[BhUIViewFrame]s at once may have a performance penalty.

### function BhUIViewFrame:init(uiview) [BhUIViewFrame:init]
Constructor for a [BhUIViewFrame] that will wrap the supplied [UIView]. It is assumed that *uiview*
will not yet have been added to the iOS root view controller. When the frame object is eventually added to the Gideros
stage, the associated [UIView] will also be added to the root view at the same time.
##### Usage:
    local uiview=UITextView:initWithFrame(CGRect(0, 0, width, height))
    local frame=BhUIViewFrame.new(uiview)
    stage:addChild(frame)
    frame:setPosition(x, y)
    GTween.new(frame, 2, {x=100, y=50})   


