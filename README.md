BhWax for Gideros 
=================

Wax is a Lua <-> Objective C bridge by Corey Johnson. This module is a plugin for Gideros SDK that allows Wax to be used in Gideros apps. Some small changes have to be made to Corey's
original Wax code so you are required to pull down a modified repository for this from:

https://github.com/bowerhaus/CoreyJohnsonWax.git

The plugin also contains some new enhancements to allow Wax to play nicely with the (relatively)
new blocks feature of Objective C.

You can read more about BhWax in [my blog entry](http://bowerhaus.eu/blog/files/hot_wax.html).

Folder Structure
----------------

This module is part of the general Bowerhaus library for Gideros mobile. There are a number of cooperating modules in this library, each with it's own Git repository. In order that the example project files will run correctly "out of the box" you should create an appropriate directory structure and clone/copy the files within it.

###/MyDocs
Place your own projects in folder below here

###/MyDocs/Library
Folder for library modules

###/MyDocs/Library/Bowerhaus
Folder containing sub-folders for all Bowerhaus libraries

###/MyDocs/Library/Bowerhaus/BhWax
Folder for THIS MODULE

###/MyDocs/Library/CoreyJohnsonWax
Folder for MODIFIED VERSION OF WAX

