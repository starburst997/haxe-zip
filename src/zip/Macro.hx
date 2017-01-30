package zip;

/**
 * Macro for this library
 */
class Macro
{
  // Simply include pako.js
  public static macro function init():Void
  {
    #if !display

    // Include pako.js (only if we're not using "openfl", since it already included!)
    if ( haxe.macro.Context.defined("js") && !haxe.macro.Context.defined("openfl") )
    {
      //trace("Included file pako");

      //haxe.macro.Compiler.includeFile("../../externs/pako_deflate.min.js");
      haxe.macro.Compiler.includeFile("../../externs/pako.min.js");
    }

    #else
    // Do nothing
    #end
  }
}