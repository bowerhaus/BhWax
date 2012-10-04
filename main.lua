--[[`
Hot Wax for Gideros 
===================

[Wax](https://github.com/probablycorey/wax) is a Lua <-> Objective C bridge by [Corey Johnson](https://github.com/probablycorey).
This module is a plugin for [Gideros SDK](http://giderosmobile.com) that allows Wax to be
used in Gideros apps. I've chosen to call this [Hot Wax] or BhWax. Some small changes have to be made to Corey's
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
 
@include "BhWaxDemo.lua"
@include "BhWaxPhysicsDemo.lua"
@include "BhWaxAutoComplete.lua"
@include "IosImagePicker.lua"
@include "BhUIViewFrame.lua"

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

-- Enable ONE of the following lines depending on which demo you want to run

BhWaxDemo.new()
-- BhWaxPhysicsDemo.new()
-- BhAutoComplete.new()