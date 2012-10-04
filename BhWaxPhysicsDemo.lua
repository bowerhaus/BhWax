--[[`
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

require "box2d"
require "accelerometer"
require "BhUIViewFrame"

BhWaxPhysicsDemo=Core.class(Sprite)

function BhWaxPhysicsDemo:onEnterFrame()
	-- Check for gravity changeActiveCategoryVolumeBy
	local x, y=accelerometer:getAcceleration()
	
	-- Apply IIR filter
	self.fx = x * self.filter + self.fx * (1 - self.filter)
	self.fy = y * self.filter + self.fy * (1 - self.filter)
     
	--Set world's gravity
	--for Portrait
	self.world:setGravity(self.fx*self.gravityScale, -self.fy*self.gravityScale)
	
	-- Move physics world on
	self.world:step(1/60, 8, 3)
	
	for body,sprite in pairs(self.actors) do
		local x0, y0, w, h=sprite:getBounds(sprite)
		sprite:setRotation(0)
		local x, y=body:getPosition()
				sprite:setRotation(body:getAngle() * 180 / math.pi)
		sprite:setPosition(x-w/2, y-h/2)
	end
end

function BhWaxPhysicsDemo:onMouseUp(event)
	self:createNewBody(event.x, event.y, 250, 150)
end

function BhWaxPhysicsDemo:createNewBody(x, y, width, height)
	local body = self.world:createBody{type = b2.DYNAMIC_BODY, position = {x=x, y=y}}
	local shape = b2.PolygonShape.new()
	shape:setAsBox(width/2, height/2)
	body:createFixture{shape = shape, density = 1, restitution = 0.9, friction = 0.3}

	local uiview=UITextView:initWithFrame(CGRect(0, 0, width, height))
	uiview:setText("This is some editable text floating around the ether")
	uiview:setFont(UIFont:boldSystemFontOfSize(24))
	--uiview:setBackgroundColor(UIColor:clearColor())
	
	local frame=BhUIViewFrame.new(uiview)
	frame:setPosition(x-width/2, y-height/2)
	self.actors[body] = frame
	stage:addChild(frame)
end

function BhWaxPhysicsDemo:init()
	stage:addChild(self)
	
	-- Use actors table to hold the physics bodies and their UIView counterparts
	self.actors = {}
	
	-- Create world
	b2.setScale(20)
	self.world = b2.World.new(0, 9.8)
	
	-- Create a playing field
	local w, h=application:getContentWidth(), application:getContentHeight()
	local bg=Shape.new()
	bg:beginPath(Shape.NON_ZERO)
	bg:setFillStyle(Shape.SOLID, 0xfeab00)
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

	-- Create a bounding box to keep everything on screen
	local border=self.world:createBody({ type=b2.STATIC_BODY })
    local chain = b2.ChainShape.new()
    chain:createLoop(0, 0, 0, h, w, h, w, 0)
    border:createFixture({shape=chain, density=1.0, friction=0.3, restitution=0.1})
	
	-- Turn on the accelerometer to set gravity force
	-- Thanks to http://appcodingeasy.com/Gideros-Mobile/Using-Accelerometer-with-Box2d-in-Gideros
	accelerometer:start()
	self.filter = 0.5
	self.fx = 0
	self.fy = 0
	self.gravityScale=10
	
	-- Listen for frame events where we make our UIViews match the physics
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
	
	-- Enable the following to see physic debugging
	--	local debugDraw = b2.DebugDraw.new()
	--	self.world:setDebugDraw(debugDraw)
	--	stage:addChild(debugDraw)
end

