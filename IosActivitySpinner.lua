--[[`
# IosActivitySpinner.lua

A neat little activity spinner implemented using [Hot Wax].
Stolen shamelessly from [Stack Overflow](http://stackoverflow.com/questions/3490991/big-activity-indicator-on-iphone).

Usage:

    IosActivitySpinner.show("Loading")	
    Timer.delayedCall(1, function() 
    	CallALongFunction()
	    IosActivitySpinner.hide()
	    end)

Note that the [Timer.delayedCall] is required to get the activity spinner up and on screen before
the time consuming code takes over the UI thread. If you don't do this you won't see anything.

[Hot Wax]: http://bowerhaus.eu/blog/files/hot_wax.html

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

--` ## Class IosActivitySpinner[IosActivitySpinner]

IosActivitySpinner=Core.class()

function IosActivitySpinner:init(labelText) 
	IosActivitySpinner.sharedInstance=self
	local loading=UIView:initWithFrame(CGRect(0, 0, 120, 120))
	loading:layer():setCornerRadius(15)
	loading:setOpaque(false)
	loading:setBackgroundColor(UIColor:colorWithWhite_alpha(0, 0.6))
	
	local label=UILabel:initWithFrame(CGRect(20, 20, 81, 22))
	label:setText(labelText)
	label:setFont(UIFont:boldSystemFontOfSize(14))
	label:setTextAlignment(UITextAlignmentCenter)
	label:setTextColor(UIColor:colorWithWhite_alpha(1, 0.8))
	label:setBackgroundColor(UIColor:clearColor())
	loading:addSubview(label)
	
	local spinning=UIActivityIndicatorView:initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
	spinning:setFrame(CGRect(42, 54, 37, 37))
	spinning:startAnimating()	
	loading:addSubview(spinning)
	
	getRootViewController():view():addSubview(loading)
	loading:setCenter(CGPoint(application:getContentWidth()/2, application:getContentHeight()/2))
	self.spinner=loading
end

function IosActivitySpinner.show(labelText) --` @public @function
	-- Show an activity spinner with the supplied label text and start it spinning.
	-- The spinner is a singleton instance of [IosActivitySpinner]. The animation is performed by
	-- iOS on a background thread so it doesn't matter if you subsequently block the UI thread; the spinner
	-- will continue to spin.
	--
	IosActivitySpinner.sharedInstance=IosActivitySpinner.new(labelText)
end

function IosActivitySpinner.hide() --` @public @function
	-- Stop any current instance of the [IosActivitySpinner] and remove it from the screen.
	IosActivitySpinner.sharedInstance.spinner:removeFromSuperview()
	IosActivitySpinner.sharedInstance=nil
end

