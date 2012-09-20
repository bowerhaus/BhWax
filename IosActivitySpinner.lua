--[[ 
IosActivitySpinner.lua

A neat little activity spinner for BhWax.
Stolen shamelessly from http://stackoverflow.com/questions/3490991/big-activity-indicator-on-iphone

Usage:

IosActivitySpinner.show("Loading")	
Timer.delayedCall(1, function() 
	CallALongFunction()
	IosActivitySpinner.hide()
	end)

Note that the Timer.delayedCall() is required to get the activity spinner up and on screen before
the time consuming code takes over the UI thread. If you don't do this you won't see anything.

MIT License
Copyright (C) 2012. Andy Bower, Bowerhaus LLP
--]]

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

function IosActivitySpinner.show(labelText)
	IosActivitySpinner.sharedInstance=IosActivitySpinner.new(labelText)
end

function IosActivitySpinner.hide()
	IosActivitySpinner.sharedInstance.spinner:removeFromSuperview()
	IosActivitySpinner.sharedInstance=nil
end

