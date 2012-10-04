--[[` 
# BhWaxAutoComplete.lua

Hot Wax allows you to write Cocoa code directly in Lua, inside the Gideros IDE. However, the ObjectiveC method selectors
are often quite long and difficult to remember. 

This demo will walk the Cocoa class object tree and generate an autocompletion file of all the class and instance
methods for the classes that you specify. This autocompletion file, "cocoa_annot.txt", can be appended to the 
"gideros_annot.api" file which is to be found in the "Gideros Studio/Contents/Resources" folder. Note that you
will have to use "Show Package Contents" to drill into the Gideros Studio applicatuion to find this location.

You must restart Gideros Studio after updating this file in order to see the new autocompletion annotations working.
 
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

BhWaxAutocomplete=Core.class(Sprite)

local TITLE_FONT_SIZE=30

function BhWaxAutocomplete:init()
	stage:addChild(self)
	
	local w, h=application:getContentWidth(), application:getContentHeight()
	local bg=Shape.new()
	bg:beginPath(Shape.NON_ZERO)
	bg:setFillStyle(Shape.SOLID, 0xc99d66)
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
	
	local label=TextField.new(TTFont.new("Fonts/Tahoma.ttf", 24), "Touch logo to generate autocomplete data")
	label:setPosition((w-label:getWidth())/2, h-100)
	self:addChild(label)
end

function BhWaxAutocomplete:onMouseUp(event)
	-- Choose the classes that you want to generate autocomplete info for here.
	if self:hitTestPoint(event.x, event.y) then
		IosActivitySpinner.show("Working")	
		self.button:setVisible(false)
		Timer.delayedCall(1000, function() 
			AutocompleteGenerator.new("|D|cocoa_annot.txt", {"GK.*", "SK.*", "CM.*", "CL.*", "CG.*", "AV.*", "AD.*", 
			"NSString", "NSNumber", "NSValue", "NSArray", "NSData", "NSDate", "NSDateFormatter", "NSDictionary", "NSEnumerator", "NSError", 
			"NSException", "NSFileHandle", "NSFileManager", "NSFormatter", "NSHashTable", "NSInputStream", "NSLocale", "NSLock", "NSMutableArray", "NSMutableDictionary",
			"NSMutableOrderedSet", "NSMutableIndexSet", "NSMutableSet", "NSMutableString", "NSNotification", "NSNumberFormatter", "NSObject", 
			"NSOperation", "NSOperationQueue", "NSOrderedSet", "NSOutputStream", "NSProcessInfo", "NSSet", "NSStream", "NSTask", "NSThread", "NSTimer", 
			"NSTimeZone", "NSURL", "NSURLRequest", "NSURLResponse", "NSUUID"}, {"UIKeyboardCandidate", ".*Proxy$"})			
			IosActivitySpinner.hide()
			self.button:setVisible(true)
		end)
	end
end


