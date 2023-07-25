package luamodchart;

import hxlua.Lua;
import hxlua.LuaL;
import hxlua.Types;
import luamodchart.LuaHandler;

class PoyoLua
{
    var vm:cpp.RawPointer<Lua_State> = LuaL.newstate();
    var hooks:Map<Array<Dynamic>> = [
        "stepHit" => [],
        "beatHit" => []
    ];

    public static function startUp(filename:String)
    {
       LuaHandler.new(Paths.modchart(filename));
       LuaHandler.setCallback('addHook', registerHook);
    }

    function registerHook(name:String, lua_function:Function)
    {
        if (hooks[name] != null)
        {
            hooks[name].push(lua_function)
        }
        trace('called registerHook')
    }

    public static function callFunction(functionName:String, args:Array<Dynamic>)
    {
        
    }
}