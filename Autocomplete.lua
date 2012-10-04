--[[`
# Autocomplete.lua

BhWax allows you to write Cocoa code directly in Lua, inside the Gideros IDE. However, the ObjectiveC method selectors
are often quite long and difficult to remember. 

This module will walk the Cocoa class object tree and generate an autocompletion file of all the class and instance
methods for the classes that you specify. This autocompletion file, *cocoa_annot.txt*, can be appended to the 
*gideros_annot.api* file which is to be found in the */Applications/Gideros Studio/Contents/Resources* folder. Note that you
will have to use **Show Package Contents** to drill into the Gideros Studio application to find this location.

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

AutocompleteGenerator=Core.class()

function AutocompleteGenerator:getAllSubclassNamesOf(class, list)
	for i,each in ipairs(class:bhSubclassNames()) do
		list[#list+1]=each
	end	
end

function AutocompleteGenerator:getClassNamesMatching(filter, exclusions)
	local allClasses={}
	self:getAllSubclassNamesOf(NSObject, allClasses)
	table.filter(allClasses, function(v) return v:find("^"..filter.."$") end)
	for i, excl in ipairs(exclusions) do
		table.filter(allClasses, function(v) return not(v:find("^"..excl.."$")) end)
	end
	table.sort(allClasses)
	return allClasses
end

function AutocompleteGenerator:generateAutocompleteListForClassesMatching(inclusions, exclusions)
	self.classMethods={}
	self.instanceMethods={}
	for i, filter in ipairs(inclusions) do
		local classes=self:getClassNamesMatching(filter, exclusions)
		for _,class in pairs(classes) do
			self:collateAutocompleteForClass(class)
		end
	end
	
	local stream=io.open(getPathForFile(self.outputFile), "w+")
	for sel,info in pairsKeySorted(self.classMethods) do
		stream:write(self:formatAutocompleteSelector(info.selector, info.className, true))
		stream:write("\n")
	end
	for sel,info in pairsKeySorted(self.instanceMethods) do
		stream:write(self:formatAutocompleteSelector(info.selector, info.className, false))
		stream:write("\n")
	end
	stream:close()
end

function AutocompleteGenerator:collateAutocompleteForClass(class)
	self:collateAutocompleteForMethods(class, true) 
	self:collateAutocompleteForMethods(class, false)
	self:collateAutocompleteForProperties(class)
end

function AutocompleteGenerator:collateAutocompleteForMethods(class, isClass)
	local cls=_G[class]
	if isClass then
		cls=cls:bhClass()
	end
	local selectors=cls:bhMethodSelectors()
	for i,selector in ipairs(selectors) do
		self:collateAutocompleteForMethod(selector, cls, class, isClass)
	end
end

function AutocompleteGenerator:collateAutocompleteForProperties(class)
	local cls=_G[class]
	local properties=cls:bhPropertyNames()
	
	for i,property in ipairs(properties) do
		self:collateAutocompleteForMethod(property, cls, class, false, self.instanceMethods)
		self:collateAutocompleteForMethod("set"..(property:gsub("^%l", string.upper)), cls, class, false, methods)
	end
end

function AutocompleteGenerator:collateAutocompleteForMethod(selector, cls, class, isClassMethod)
	if not(selector:find("^_")) then
		local key=selector
		local methods=self.instanceMethods
		if isClassMethod then
			key=class..":"..key
			methods=self.classMethods
		end
		methods[key:upper()]={className=class, selector=selector, isClassMethod=isClassMethod}
	end
end

function AutocompleteGenerator:formatAutocompleteSelector(selector, className, isClassMethod)
	if not(selector:find("^_")) then
		-- Ignore hidden selectors beginning with "_"
		local selStream=WriteStream.new()
		local paramStream=WriteStream.new()
		
		-- Are there any parameters?
		if selector:find(":") then
			local first=true
			for tag in selector:gmatch("[^:]+") do
			   selStream:put(tag)
			   selStream:put("_")
			   if first then
					-- Here's a guess for the first parameter
					local param1=(tag:match(".*(%u+.*)$") or selector):lower()
					paramStream:put(param1)
				else
					paramStream:put(",")
					paramStream:put(tag)
				end
			   first=false
			end
			selector=selStream:contents():match("(.*)_$")
		end 
		local params=paramStream:contents()	or ""
		if isClassMethod then
			return string.format("%s:%s(%s) %s", className, selector, params, className)
		else
			return string.format("%s(%s)", selector, params)
		end
	end
end

function AutocompleteGenerator:init(outputFile, inclusions, exclusions)
	self.outputFile=outputFile
	self:generateAutocompleteListForClassesMatching(inclusions, exclusions)
end

