package;

/**
 * Macro for this library
 */
class Macro 
{
  // Simply include pako.js
  public static macro function init():Void 
  {
    #if !display

    // Include pako.js (only if we're not using "openfl")
    if ( haxe.macro.Context.defined("js") && !haxe.macro.Context.defined("openfl") )
    {
      haxe.macro.Compiler.includeFile("../externs/pako_deflate.min.js");
    }
    
    #else 
    // Do nothing
    #end
  }
}