//
// BhWax.mm
// Wax Lua-ObjectiveC bridge plugin for Gideros Studio (IOS Only)
//
// MIT License
// Copyright (C) 2012. Andy Bower, Bowerhaus LLP
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software
// and associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute,
// sublicense, and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
// BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <sys/socket.h>
#include "gideros.h"

extern "C"{
    #include "wax.h"
    #include "wax_helpers.h"
}

@interface WaxFunction : NSObject {}
@end

@interface WaxFunction (Blocks)
- (void (^)())asVoidNiladicBlock;
- (void (^)( NSObject *))asVoidMonadicBlock;
- (void (^)( NSObject *, NSObject *))asVoidDyadicBlock;
@end

@implementation WaxFunction (Blocks)

-(void (^)())asVoidNiladicBlock {
    return [[^() {
        lua_State *L = wax_currentLuaState();
        wax_fromInstance(L, self);
        lua_call(L, 1, 0);
    } copy] autorelease];
}

-(void (^)(NSObject *p))asVoidMonadicBlock {
    return [[^(NSObject *param) {
        lua_State *L = wax_currentLuaState();
        wax_fromInstance(L, self);
        wax_fromInstance(L, param);
        lua_call(L, 1, 0);
    } copy] autorelease];
}

-(void (^)(NSObject *p1, NSObject * p2))asVoidDyadicBlock {
    return [[^(NSObject *param1, NSObject *param2) {
        lua_State *L = wax_currentLuaState();
        wax_fromInstance(L, self);
        wax_fromInstance(L, param1);
        wax_fromInstance(L, param2);
        lua_call(L, 2, 0);
    } copy] autorelease];
}
@end

static int getRootViewController(lua_State* L)
{

	UIViewController* controller = g_getRootViewController();
    wax_fromInstance(L, controller);

	return 1;
}

static int loader(lua_State *L)
{
    //This is a list of functions that can be called from Lua
    const luaL_Reg functionlist[] = {
        {NULL, NULL},
    };
    luaL_register(L, "wax", functionlist);

    lua_pushcfunction(L, getRootViewController);
   	lua_setglobal(L, "getRootViewController");

    //return the pointer to the plugin
    return 1;
}

static void g_initializePlugin(lua_State* L)
{
    wax_setCurrentLuaState(L);
    wax_setup();
    
    lua_getglobal(L, "package");
    lua_getfield(L, -1, "preload");

    lua_pushcfunction(L, loader);
    lua_setfield(L, -2, "wax");

    lua_pop(L, 2);
}

static void g_deinitializePlugin(lua_State *) {
    // If we've added any subviews to the root view then we should remove them
    // since this will clear down the player's screen for a subsequent run.
    // We need to leave the original EAGLView though.

    UIView *rootView= [g_getRootViewController() view];
    for (UIView *subview in [rootView subviews]) {
        NSString *className= NSStringFromClass([subview class]);
        if (![className isEqualToString:@"EAGLView"]) {
            [subview removeFromSuperview];
        }
    }

    // Stop Wax
    wax_end();
}

REGISTER_PLUGIN("wax", "1.0")

