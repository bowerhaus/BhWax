
--[[ 
BhWaxDemo

A quick demonstration of the Wax Lua-ObjectiveC bridge as tuned for Gideros SDK. 

KUDOS TO COREY JOHNSON (https://github.com/probablycorey). This Wax stuff is truly magic!

ONLY FOR IOS.

In this demo we bring up a native IOS ImagePicker and allow the user to choose a photo from the photo
library. Once an image is picked, it is resized and saved to our documents directory from where it
is loaded as a standard Gideros Bitmap. You are then given the opportunity to write a title for the
photo using an IOS multiline UITextView. After that, if you click on the YouTube logo, you'll see a 
video showing how to get started with Wax and Gideros.

In order for this example to work, the Gideros Player must be built will the BhWax plugin and the
associated files for Wax itself. You will also need one additional ObjectiveC file (UIImage+Save.m) which
contains a protocol extension to allow UIImage objects to resize and save themselves (see comment in
BhWaxDemo:onPickedImage() below).
 
MIT License
Copyright (C) 2012. Andy Bower, Bowerhaus LLP

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

-- ======== BhWaxDemo ===========

BhWaxDemo=Core.class(Sprite)

local TITLE_FONT_SIZE=30

function BhWaxDemo:init()
	stage:addChild(self)
	
	local w, h=application:getContentWidth(), application:getContentHeight()
	local bg=Shape.new()
	bg:beginPath(Shape.NON_ZERO)
	bg:setFillStyle(Shape.SOLID, 0x7b9f2a)
	bg:moveTo(0, 0)
	bg:lineTo(w, 0)
	bg:lineTo(w, h)
	bg:lineTo(0, h)
	bg:lineTo(0, 0)
	bg:endPath()
	self:addChild(bg)
	
	local button=Bitmap.new(Texture.new("Images/HotWax.png"))
	button:setAnchorPoint(0.52, 0.48)
	button:setPosition(w/2, h/2)
	self:addChild(button)	
	button:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	self.button=button
	
	local label=TextField.new(TTFont.new("Fonts/Tahoma.ttf", 24), "Touch logo to start demo")
	label:setPosition((w-label:getWidth())/2, h-100)
	self:addChild(label)
	self.label=label
end

function BhWaxDemo:onMouseUp(event)
	if self.button:hitTestPoint(event.x, event.y) then
		self.button:removeFromParent()
		self.label:removeFromParent()
		local picker=IosImagePicker:init()
		picker:pickImage(UIImagePickerControllerSourceTypePhotoLibrary, self.onImagePicked, self) 
		event:stopPropagation()
	end
end

function BhWaxDemo:onImagePicked(image)
	-- You have to have included UIImage+Save.m in your plugin or app
	-- to allow the following lines to scale down and save the supplied image. It's pretty cool
	-- that even extension protocols like this work with Wax.
	
	-- Resize the image and save it as a PNG to our documents folder.
	-- Note that because the Core Image functions required to to this (UIImagePNGRepresentation() among other) 
	-- are simply plain C functions, we can't get hold of them from Wax. Hence the need to create a simple OBJC
	-- wrapper protocol (see UIImage_Save.m)
	--

	local w, h=application:getContentWidth(), application:getContentHeight()
	local smallest=math.min(w, h)
	image=image:resize(CGSize(smallest*2/3, smallest*2/3))
	print(image:savePNG("|D|pickedImage.png"))	

	-- Notice how Wax gives good debug prints
	print("Picked an image:", image, image:size())
	
	-- Now create a Gideros Bitmap and load our chosen image back in
	local bitmap=Bitmap.new(Texture.new("|D|pickedImage.png"))
	bitmap:setAnchorPoint(0.5, 0.5)
	bitmap:setPosition(application:getContentWidth()/2, application:getContentHeight()/3)
	stage:addChild(bitmap)
	self.bitmap=bitmap
	--]]
	
	-- Give the user a chance to type in a title
	self:createTitle()
	
	-- and to see how it's done
	self:createYouTubeButton()
end

function BhWaxDemo:onTitleEdited(title)
	-- Handler for the title edit being complete
	AlertDialog.new("Nice Title", title:text(), "OK"):show()
end
	
function BhWaxDemo:createTitle()
	local w, h=application:getContentWidth(), application:getContentHeight()
	local font=UIFont:boldSystemFontOfSize(TITLE_FONT_SIZE)
	local titleWidth=self.bitmap:getWidth()
	
	-- Put up a UITextView (chosen over UITextField because it is multiline) so we can edit
	-- the photo title.
	local titleField=UITextView:initWithFrame(
		CGRect((w-titleWidth)/2, self.bitmap:getY()+TITLE_FONT_SIZE, 
		titleWidth, TITLE_FONT_SIZE*3))
		
	titleField:setFont(font)
	titleField:setText("Touch here to edit title")
	titleField:setTextAlignment(UITextAlignmentCenter)
	titleField:setTextColor(UIColor:whiteColor())
	titleField:setBackgroundColor(UIColor:clearColor())
	
	-- Show the text inside the root view contrller supplied by Gideros
	-- Touching the field will pull up an IOS keyboard
	getRootViewController():view():addSubview(titleField)
	
	-- Just for fun let us install a delegate to capture notifications from
	-- the UITextView. To do this we have to create a helper class, TextViewDelegate,
	-- which can forward notification calls back to our handler.
	-- NOTE: There might be a better way of doing this, experience will tell.
	
	local delegate=TextViewDelegate:init()
	delegate.handlerTarget=self
	delegate.textViewDidEndEditingHandler=self.onTitleEdited
	titleField:setDelegate(delegate)
end

function BhWaxDemo:createYouTubeButton()
	local w, h=application:getContentWidth(), application:getContentHeight()
	local button=Bitmap.new(Texture.new("Images/YouTube.png"))
	button:setAnchorPoint(0.5, 0.5)
	button:setPosition(w/2, h*0.75)
	button:addEventListener(Event.MOUSE_UP, function(event)
		if self:hitTestPoint(event.x, event.y) then
			self:playVideo("http://www.youtube.com/watch?v=zu1lTI4AtE8", (w-500)/2, 600, 500, 500/1.66)
			button:removeFromParent()
		end
	end)
	self:addChild(button)
end

local function set(self, param, value)
	-- We can install this property set function on a Wax class instance
	-- to allow us to GTween that instance.
	if param=="scaleX" then
		local transform=self:transform()
		transform.a=value
		self:setTransform(transform)
	end
	if param=="scaleY"  then
		local transform=self:transform()
		transform.d=value
		self:setTransform(transform)
	end
end

local function get(self, param)
	-- We can install this property get function on a Wax class instance
	-- to allow us to GTween that instance.
	if param=="scaleX" then
		local transform=self:transform()
		return transform.a
	end
	if param=="scaleY" then
		local transform=self:transform()
		return transform.d
	end
end

local function makeTweenable(object)
	object.get=get
	object.set=set
end

function BhWaxDemo:playVideo(url, x, y, width, height)
	local html = string.format("\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%s\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>", url, width, height)
	
	local videoView=UIWebView:initWithFrame(CGRect(x, y, width, height))
	videoView:loadHTMLString_baseURL(html, nil)
	
	-- Install some property accessor functions to allow tweening, which will
	-- look pretty funky while the video is playing.
	--
	makeTweenable(videoView)
	videoView:set("scaleX", 0.8)
	videoView:set("scaleY", 0.8)	
--	GTween.new(videoView, 2, {scaleX=1.1, scaleY=1.1}, {reflect=true, repeatCount=0, ease=easing.inOutSine})
	
	getRootViewController():view():addSubview(videoView)
end

-- ======== TextViewDelegate ========

-- The TextViewDelegate class is an ObjectiveC class that we create to capture
-- UITextView delegate (notification) messages. This shows the power of Wax; on the
-- ObjectiveC side it is just like any normal class but, in addition, on the Lua side
-- it can hold Lua data fields too. In this case we hold a Lua handler function (and target)
-- that can be used to handle the notifications.

waxClass({"TextViewDelegate", protocols={"UITextViewDelegate"}})	

function TextViewDelegate:textViewDidEndEditing(field)
	if self.textViewDidEndEditingHandler then
		self.textViewDidEndEditingHandler(self.handlerTarget, field)
	end
end

-- ======== End ========

BhWaxDemo.new()


