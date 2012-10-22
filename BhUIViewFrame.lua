--[[`
# BhUIViewFrame.lua

Implements [BhUIViewFrame]; a useful wrapper around Wax [UIView]s that allow them to be manipulated in 
much the same way as Gideros [Sprite]s.

[UIView]: http://developer.apple.com/library/ios/#documentation/uikit/reference/UIView_Class/UIView/UIView.html
  
@private 
MIT License: Copyright (C) 2012. Andy Bower, Bowerhaus LLP

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
## Class BhUIViewFrame[BhUIViewFrame]

A [BhUIViewFrame] may be placed in the normal Gideros display hierarchy and can be moved
around with tweening or physics. The [UIView] associated with this frame will be automatically matched up in terms of
position, size, rotation, visibility and also alpha. 

Note that this uses an **ENTER_FRAME** handler to apply the transformations and each of these many involve several Wax calls.
Hence, even though we try to minimise the effort when nothing has been changed, you should be aware that animating many 
[BhUIViewFrame]s at once may have a performance penalty.
--]] 

BhUIViewFrame=Core.class(Shape) 

local function uiSetRotation(self, angle)
	-- Taxing my matrix maths to the limit :-)
	local rad=math.rad(angle)
	local transform=self:transform()
	transform.a=math.cos(rad)
	transform.b=math.sin(rad)
	transform.c=-math.sin(rad)
	transform.d=math.cos(rad)
	self:setTransform(transform)
end

function BhUIViewFrame:applyTransform()
	local x0, y0, width, height=self:getBounds(self)
	local sx, sy=self:getScale()
	local x, y=self:localToGlobal(x0, y0)	
	local rotation=self:getRotation()
	local w, h=width*sx, height*sy
	
	local hash=x..y..rotation..w..h
	if hash ~= self._hash then	
		-- Use a (simplistic) hash to try and avoid making the following 
		-- Wax calls when nothing has changed
		uiSetRotation(self.uiview, 0)
		self.uiview:setFrame(CGRect(x, y, width*sx, height*sy))
		uiSetRotation(self.uiview, self:getRotation())
		self._hash=hash
	end
	
	local alpha=self:getAlpha()
	if self._alpha ~= alpha then
		-- Similarly, only set alpha when iit has changed
		self.uiview:setAlpha(alpha)
		self._alpha=alpha
	end
	
	local visible=self:isVisibleDeeply()
	if self._visible ~= visible then
		-- And only set visble if it has changed
		self.uiview:setHidden(not(visible))
		self._visible=visible
	end
	
end

function BhUIViewFrame:onEnterFrame()
	-- Every fram we ask our associated UIView to match up to our frame
	self:applyTransform()
end

function BhUIViewFrame:onAddedToStage()
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	getRootViewController():view():addSubview(self.uiview)
end

function BhUIViewFrame:onRemovedFromStage()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self.uiview:removeFromSuperview()
end

function BhUIViewFrame:set(param, value)
	-- Add width and height parameters for tweening etc
	if param=="width" then
		self:setWidth(value)
	elseif param=="height" then
		self:setHeight(value)
	else
		Shape.set(self, param, value)
	end
end

function BhUIViewFrame:get(param)
	-- Add width and height parameters for tweening etc
	if param=="width" then
		return self:getWidth()
	elseif param=="height" then
		return self:getHeight()
	end
	return Shape.get(self, param)
end

function BhUIViewFrame:getWidth()
	local x0, y0, width, height=self:getBounds(self)
	return width
end

function BhUIViewFrame:getHeight()
	local x0, y0, width, height=self:getBounds(self)
	return height
end

function BhUIViewFrame:setWidth(width)
	self:bhSetWidth(width)
end

function BhUIViewFrame:setHeight(height)
	self:bhSetHeight(height)
end

function BhUIViewFrame:setSize(width, height)
	self:setWidth(width)
	self:setHeight(height)
end

function BhUIViewFrame:init(uiview, optFrame) --` @public @function
	-- Constructor for a [BhUIViewFrame] that will wrap the supplied [UIView]. It is assumed that *uiview*
	-- will not yet have been added to the iOS root view controller. When the frame object is eventually added to the Gideros
	-- stage, the associated [UIView] will also be added to the root view at the same time.
	-- ##### Usage:
	--     local uiview=UITextView:initWithFrame(CGRect(0, 0, width, height))
	--     local frame=BhUIViewFrame.new(uiview)
	--     stage:addChild(frame)
	--     frame:setPosition(x, y)
	--     GTween.new(frame, 2, {x=100, y=50})   
	
	-- Use an invisible Shape to give us a tangible area
	local frame=optFrame or uiview:frame()
	self:beginPath(Shape.NON_ZERO)
	self:moveTo(frame.x, frame.y)
	self:lineTo(frame.x+frame.width, frame.y)
	self:lineTo(frame.x+frame.width, frame.y+frame.height)
	self:lineTo(frame.x, frame.y+frame.height)
	self:lineTo(frame.x, frame.y)
	self:endPath()
	
	self.uiview=uiview

	self:addEventListener(Event.ADDED_TO_STAGE, self.onAddedToStage, self)
	self:addEventListener(Event.REMOVED_FROM_STAGE, self.onRemovedFromStage, self)
end
