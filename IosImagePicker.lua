--[[`
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

@private
## MIT License: Copyright (C) 2012. Andy Bower, Bowerhaus LLP

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

--[[`
## Class IosImagePicker [IosImagePicker]

[IosImagePicker] is a Wax Class that brings up an iOS ImagePicker dialog to allow the user to choose an image from the
device camera or photo library. The picked image will be passed to a callback handler function as an [UIImage] object.
--]]

waxClass({"IosImagePicker", NSObject, protocols={ "UIPopoverControllerDelegate", "UIImagePickerControllerDelegate"}})

function IosImagePicker:init()
	local picker=UIImagePickerController:init() 
	return self
end

function IosImagePicker:isIPad() 
	-- Answer true if the current device is an iPad
	local model=UIDevice:currentDevice():model()
	return string.find(model, "iPad")==1
end

function IosImagePicker:pickImage(sourceType, handlerFunc, handlerTarget) --` @public @function
	-- Bring up an image picker based on what sort of device we are running on. We are passed a callback handler function to use when an image is chosen by the user.
	--
	-- - **sourceType** 	- an integer describing the device location where the image should be picked
	--						from. Can be one of the *UIImagePickerControllerSourceType* enum values. 
	--						Hence, *UIImagePickerControllerSourceTypePhotoLibrary*, *UIImagePickerControllerSourceTypeCamera*, *UIImagePickerControllerSourceTypeSavedPhotosAlbum* are valid options.   
	-- - **handlerFunc** 	- the function that will be called when an image has been picked. The picked image is passed as an [UIImage] parameter.   
	-- - **handlerTarget** 	- (optional) target object of the handler function if it is an instance method.
	--
	-- ##### Typical usage:
	--
	--      local picker=IosImagePicker:init()
	--      picker:pickImage(UIImagePickerControllerSourceTypePhotoLibrary, self.onImagePicked, self) 
	--
	--      function MyClass:onImagePicked(uiImage)		
	--   	    uiImage:savePNG("|D|pickedImage.png")
	--      end
	
self.handlerFunc=handlerFunc
	self.handlerTarget=handlerTarget
	
	if self:isIPad() then
		self:pickImageIPad(sourceType)
	else
		self:pickImageIPhone(sourceType)
	end
end

function IosImagePicker:pickImageIPad(sourceType)
	-- The iPad requires that we display a popover controller around the picker itself
	local picker=UIImagePickerController:init()
	picker:setSourceType(sourceType)
	picker:setWantsFullScreenLayout(true)
	picker:setDelegate(self)
	self.picker=picker
	
	local popover=UIPopoverController:initWithContentViewController(picker)
	popover:setDelegate(self)
	self.popover=popover
	
	local rootController=getRootViewController()
	local rootView=rootController:view()	
	local bounds=rootView:bounds()
	
	popover:setPopoverContentSize_animated(CGSize(bounds.width, bounds.height), false)	
	popover:presentPopoverFromRect_inView_permittedArrowDirections_animated(rootView:frame(), rootView, 0, true)
	return true
end

function IosImagePicker:pickImageIPhone(sourceType)
	-- The iPhone/iPod simply needs the picker to be displayed inside the root controller
	local picker=UIImagePickerController:init()
	picker:setSourceType(sourceType)
	picker:setWantsFullScreenLayout(true)
	picker:setDelegate(self)
	self.picker=picker
	
	local rootController=getRootViewController()
	rootController:presentModalViewController_animated(picker, true)
	return true
end

function IosImagePicker:dismiss()
	-- Dismiss the picker and any popover controller
	if self.picker then
		self.picker:dismissModalViewControllerAnimated(true)
		self.picker:view():removeFromSuperview()
		self.picker=nil
	end
	if self.popover then
		self.popover:dismissPopoverAnimated(true)
		self.popover=nil
	end
end

function IosImagePicker:popoverControllerDidDismissPopover(controller)
	-- Come here if we are on an iPad and the user touches outside of the popup controller
	self:dismiss()
end

function IosImagePicker:imagePickerControllerDidCancel(controller)
	-- Come here if we are on an iPhone/iPod and the user cancels the picker
	self:dismiss()
end

function IosImagePicker:imagePickerController_didFinishPickingMediaWithInfo(controller, info)
    -- Dismiss BEFORE accessing the info dictionary
	-- See: http://stackoverflow.com/questions/3088874/didfinishpickingmediawithinfo-return-nil-photo/4192109
	--
	self:dismiss()
	local image=info["UIImagePickerControllerOriginalImage"]
	if self.handlerFunc then
		-- Get the original UIImage and call back to our handler function (if supplied)
		self.handlerFunc(self.handlerTarget or image, image)
	end
end
