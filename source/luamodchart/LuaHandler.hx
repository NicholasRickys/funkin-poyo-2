package luamodchart;

// MA JIGSAW THE GOOOOAOAOATOAOTJADKTJAKKLF
// he made this entire thing + the hxlua lib

#if (android && debug)
import android.widget.Toast;
#end
import haxe.Constraints;
import haxe.DynamicAccess;
import hxlua.Lua;
import hxlua.LuaL;
import hxlua.Types;
import openfl.Lib;

using StringTools;

class LuaHandler
{
	public static final Function_Continue:String = 'Function_Continue';
	public static final Function_Stop:String = 'Function_Stop';

	public static var callbacks:Map<String, Function> = [];

	private var vm:cpp.RawPointer<Lua_State>;

	public function new(path:String):Void
	{
		// create a new lua instance
		vm = LuaL.newstate();

		LuaL.openlibs(vm);

		Lua.register(vm, "print", cpp.Function.fromStaticFunction(print));

		set('Function_Continue', Function_Continue);
		set('Function_Stop', Function_Stop);

		// make a new file with the instance and check if it can be ran
		var status:Int = LuaL.dofile(vm, path);
		if (status != Lua.OK)
		{
			var error:String = getErrorMessage(status, 0);
			if (error == null)
				return close();

			Lib.application.window.alert(error, 'Lua Script Error!');
			return close();
		}
	}

	public function call(name:String, ?args:Array<Any>):Any
	{
		if (vm == null)
			return Function_Continue;

		if (args == null)
			args = [];

		Lua.getglobal(vm, name);

		var type:Int = Lua.type(vm, -1);

		if (type != Lua.TFUNCTION)
		{
			if (type > Lua.TNIL)
				Lib.application.window.alert("attempt to call a " + Lua.typename(vm, type) + " value as a callback", 'Lua Call Error!');

			Lua.pop(vm, 1);
			return Function_Continue;
		}

		for (arg in args)
			toLua(vm, arg);

		var status:Int = Lua.pcall(vm, args.length, 1, 0);
		if (status != Lua.OK)
		{
			var error:String = getErrorMessage(status);
			if (error == null)
				return Function_Continue;

			Lib.application.window.alert(error, 'Lua Call Error!');
			return Function_Continue;
		}

		var result:Any = fromLua(vm, -1);
		if (result == null)
			result = Function_Continue;

		Lua.pop(vm, 1);
		return result;
	}

	public function set(name:String, value:Any):Void
	{
		if (vm == null)
			return;

		toLua(vm, value);
		Lua.setglobal(vm, name);
	}

	public function get(name:String):Any
	{
		if (vm == null)
			return null;

		Lua.getglobal(vm, name);
		var ret:Any = fromLua(vm, -1);
		if (ret != null)
			Lua.pop(vm, 1);

		return ret;
	}

	public function setToTable(table:String, name:String, value:Any):Void
	{
		if (vm == null)
			return;

		Lua.getglobal(vm, table);

		if (Lua.istable(vm, -1) == 1)
		{
			Lua.pushstring(vm, name);
			toLua(vm, value);
			Lua.settable(vm, -3);
		}

		Lua.pop(vm, 1);
	}

	public function getFromTable(table:String, name:String):Any
	{
		if (vm == null)
			return null;

		Lua.getglobal(vm, table);
		Lua.getfield(vm, -1, name);

		var ret:Dynamic = fromLua(vm, -1);
		if (ret != null)
			Lua.pop(vm, 1);

		return ret;
	}

	public function close():Void
	{
		if (vm == null)
			return;

		Lua.close(vm);
		vm = null;
	}

	public function setCallback(name:String, callback:Function):Void
	{
		if (vm == null || (vm != null && (callback != null && !Reflect.isFunction(callback))))
			return;

		callbacks.set(name, callback);

		Lua.pushstring(vm, name);
		Lua.pushcclosure(vm, cpp.Function.fromStaticFunction(callbackHandler), 1);
		Lua.setglobal(vm, name);
	}

	public function removeCallback(name:String):Void
	{
		if (vm == null)
			return;

		callbacks.remove(name);

		Lua.pushnil(vm);
		Lua.setglobal(vm, name);
	}

	private static function callbackHandler(L:cpp.RawPointer<Lua_State>):Int
	{
		/* callback name */
		var name:String = Lua.tostring(L, Lua.upvalueindex(1));

		var n:Int = Lua.gettop(L);

		var args:Array<Any> = [];
		for (i in 0...n)
			args[i] = fromLua(L, i + 1);

		/* clear the stack */
		Lua.pop(L, n);

		if (callbacks.exists(name))
		{
			var ret:Dynamic = Reflect.callMethod(null, callbacks.get(name), args);
			if (ret != null)
			{
				toLua(L, ret);
				return 1;
			}
		}

		return 0;
	}

	private static function print(L:cpp.RawPointer<Lua_State>):Int
	{
		var n:Int = Lua.gettop(L);

		/* loop through each argument */
		for (i in 0...n)
		{
			#if (android && debug)
			Toast.makeText(cast(Lua.tostring(L, i + 1), String), Toast.LENGTH_SHORT);
			#else
			Sys.println(cast(Lua.tostring(L, i + 1), String));
			#end
		}

		/* clear the stack */
		Lua.pop(L, n);
		return 0;
  	}

	private function getErrorMessage(status:Int, ?number:Int = 1):String
	{
		var ret:String = Lua.tostring(vm, -1);
		Lua.pop(vm, number);

		if (ret != null)
			ret = ret.trim();

		if (ret == null || (ret != null && ret.length <= 0))
		{
			switch (status)
			{
				case e if (e == Lua.ERRRUN):
					return "Runtime Error";
				case e if (e == Lua.ERRMEM):
					return "Memory Allocation Error";
				case e if (e == Lua.ERRERR):
					return "Critical Error";
				default:
					return "Unknown Error";
			}
		}

		return ret;
	}

	public static function toLua(L:cpp.RawPointer<Lua_State>, object:Any):Bool
	{
		switch (Type.typeof(object))
		{
			case TNull:
				Lua.pushnil(L);
			case TBool:
				Lua.pushboolean(L, object ? 1 : 0);
			case TInt | TFloat:
				Lua.pushnumber(L, cast(object, Float));
			case TClass(String):
				Lua.pushstring(L, cast(object, String));
			case TClass(Array):
				var tArray:Array<Any> = cast object;

				Lua.createtable(L, tArray.length, 0);

				for (i in 0...tArray.length)
				{
					Lua.pushnumber(L, i + 1);
					toLua(L, tArray[i]);
					Lua.settable(L, -3);
				}
			case TClass(haxe.ds.StringMap) | TClass(haxe.ds.ObjectMap):
				var tLen:Int = 0;
				for (n => val in object)
					tLen++;

				Lua.createtable(L, tLen, 0);

				for (n => val in object)
				{
					Lua.pushstring(L, Std.string(n));
					toLua(L, val);
					Lua.settable(L, -3);
				}
			case TObject:
				var tLen:Int = 0;
				for (n in Reflect.fields(object))
					tLen++;

				Lua.createtable(L, tLen, 0);

				for (n in Reflect.fields(object))
				{
					Lua.pushstring(L, n);
					toLua(L, Reflect.field(object, n));
					Lua.settable(L, -3);
				}
			default:
				trace('Cannot convert ${Type.typeof(object)} to Lua');
				return false;
		}

		return true;
	}

	public static function fromLua(L:cpp.RawPointer<Lua_State>, v:Int):Any
	{
		var ret:Any = null;

		switch (Lua.type(L, v))
		{
			case t if (t == Lua.TNIL):
				ret = null;
			case t if (t == Lua.TBOOLEAN):
				ret = Lua.toboolean(L, v) == 1 ? true : false;
			case t if (t == Lua.TNUMBER):
				ret = Lua.tonumber(L, v);
			case t if (t == Lua.TSTRING):
				ret = cast(Lua.tostring(L, v), String);
			case t if (t == Lua.TTABLE):
				var count:Int = 0;
				var array:Bool = true;

				Lua.pushnil(L);

				while (Lua.next(L, v < 0 ? v - 1 : v) != 0)
				{
					if (array)
					{
						if (Lua.type(L, -2) != Lua.TNUMBER)
							array = false;
						else
						{
							var index:Float = Lua.tonumber(L, -2);
							if (index < 0 || Std.int(index) != index)
								array = false;
						}
					}

					count++;
					Lua.pop(L, 1);
				}

				if (count == 0)
					ret = {};
				else if (array)
				{
					var vArray:Array<Any> = [];

					Lua.pushnil(L);

					while (Lua.next(L, v < 0 ? v - 1 : v) != 0)
					{
						vArray[Std.int(Lua.tonumber(L, -2)) - 1] = fromLua(L, -1);
						Lua.pop(L, 1);
					}

					ret = cast vArray;
				}
				else
				{
					var vAccess:DynamicAccess<Any> = {};

					Lua.pushnil(L);

					while (Lua.next(L, v < 0 ? v - 1 : v) != 0)
					{
						switch (Lua.type(L, -2))
						{
							case t if (t == Lua.TSTRING):
								vAccess.set(cast(Lua.tostring(L, -2), String), fromLua(L, -1));
							case t if (t == Lua.TNUMBER):
								vAccess.set(Std.string(Lua.tonumber(L, -2)), fromLua(L, -1));
						}

						Lua.pop(L, 1);
					}

					ret = cast vAccess;
				}
			default:
				trace('Cannot return ${Lua.typename(L, v)} in Haxe');
				ret = null;
		}

		return ret;
	}
}
