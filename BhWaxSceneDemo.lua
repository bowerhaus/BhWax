--[[`
# BhWaxSceneDemo.lua

The intention behind this demonstration is to show how [UIButton]s created using [Hot Wax] and wrapped with [BhUIViewFrame] 
objects can obey the rules of the Gideros SceneManager. As an aside this sample also shows the use of the
Text to Speech feature that is available as part of Google Translate.

[Hot Wax]: http://bowerhaus.eu/blog/files/hot_wax.html
[UIButton]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIButton_Class/UIButton/UIButton.html]

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

function speak(text, lang)
	-- Function to speak (asynchronously) a piece of text in a given language.
	--
	local textToSend=text:gsub(" ", "+")
	local ttsUrl=string.format("http://translate.google.com/translate_tts?tl=%s&q=%s", lang or "en", textToSend)
	local ttsData = NSData:dataWithContentsOfURL(NSURL:URLWithString(ttsUrl))
	local avPlayer = AVAudioPlayer:initWithData_error(ttsData, nil) 
	avPlayer:play()
end

DemoScene1=Core.class(Sprite)

function DemoScene1:onSceneEnterEnd()
	speak("Here we are in the United Kingdom. Press the button to go to France.")
	
end

function DemoScene1:init()
	local bg=Shape.bhMakeRect(0, 0, application:getContentWidth(), application:getContentHeight(), nil, 0xff0000)
	self:addChild(bg)
	self:addEventListener("enterEnd", self.onSceneEnterEnd, self)
	
	local button=UIButton:buttonWithType(UIButtonTypeRoundedRect)
	button:setTitle_forState("Press me to go to France", UIControlStateNormal)
	button.delegate=ControlDelegate:init(button, UIControlEventTouchUpInside, self.onButtonClicked, self)
	
	local buttonFrame=BhUIViewFrame.new(button, CGRect((768-200)/2, (1024-100)/2, 200, 100))
	self:addChild(buttonFrame)
	
	local image=UIImage:imageWithContentsOfFile(getPathForFile("|R|Images/uk.png"))
	local imageView=UIImageView:initWithImage(image)
	local imageFrame=BhUIViewFrame.new(imageView, CGRect((768-200)/2, 100, 216, 216))
	self:addChild(imageFrame)
end

function DemoScene1:onButtonClicked()
	BhWaxSceneDemo.sharedInstance.sceneManager:changeScene("scene2", 1, SceneManager.moveFromRight)
end

DemoScene2=Core.class(Sprite)

function DemoScene2:onSceneEnterEnd()
	speak("Nous sommes ici en France. Appuyez sur la touche pour revenir au Royaume-Uni", "fr")	
end

function DemoScene2:init()
	local bg=Shape.bhMakeRect(0, 0, application:getContentWidth(), application:getContentHeight(), nil, 0x0000ff)
	self:addChild(bg)
	self:addEventListener("enterEnd", self.onSceneEnterEnd, self)
	
	local button=UIButton:buttonWithType(UIButtonTypeRoundedRect)
	button:setTitle_forState("Appuyez-moi de revenir", UIControlStateNormal)
	button.delegate=ControlDelegate:init(button, UIControlEventTouchUpInside, self.onButtonClicked, self)
	local buttonFrame=BhUIViewFrame.new(button, CGRect((768-200)/2, (1024-100)/2, 200, 100))
	self:addChild(buttonFrame)
	
	local image=UIImage:imageWithContentsOfFile(getPathForFile("|R|Images/fr.png"))
	local imageView=UIImageView:initWithImage(image)
	local imageFrame=BhUIViewFrame.new(imageView, CGRect((768-200)/2, 100, 216, 216))
	self:addChild(imageFrame)
end

function DemoScene2:onButtonClicked()
	BhWaxSceneDemo.sharedInstance.sceneManager:changeScene("scene1", 1, SceneManager.moveFromLeft)
end

BhWaxSceneDemo=Core.class(Sprite)

function BhWaxSceneDemo:init()
	self.sceneManager=SceneManager.new({
		["scene1"]=DemoScene1,
		["scene2"]=DemoScene2,
		})
	
	self.sceneManager:changeScene("scene1")
	stage:addChild(self.sceneManager)
	
	BhWaxSceneDemo.sharedInstance=self
end

-- ======== ControlDelegate ========

-- The ControlDelegate class is an ObjectiveC class that we can use to capture
-- UIControl delegate (notification) messages. This shows the power of Wax; on the
-- ObjectiveC side it is just like any normal class but, in addition, on the Lua side
-- it can hold Lua data fields too. In this case we hold a Lua handler function (and target)
-- that can be used to handle the notifications.

waxClass({"ControlDelegate"})	

function ControlDelegate:init(uicontrol, eventMask, func, target)
	uicontrol:addTarget_action_forControlEvents(self, "onAction", eventMask)
	self.func=func
	self.target=target
	return self
end

function ControlDelegate:onAction()
	self.func(self.target)
end

-- ======== End ========