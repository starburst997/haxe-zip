package zip;

import haxe.io.BufferInput;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.Compress;
import haxe.zip.InflateImpl;

import zip.ZipEntry;

#if lime
#if (lime >= "7.0.0")
import lime._internal.format.Deflate;
#else
import lime.utils.compress.Deflate;
#end
#end

/**
 * Taken from the haxe.zip.Reader class
 *
 * Some small modification includes the ability to get Entry without reading the bytes
 * Usefull when you don't want to necessarily have access to each items right away
 */
class Zip
{
  public static var buf:BufferInput;
  public static var tmp:Bytes;
  
  // No need to instantiate
  private function new() { }
  
  // Get Bytes out of a Zip Entry
  public static function getBytes( f:ZipEntry )
  {
    if ( f.data == null )
    {
      f.input.position = f.position;

      if ( f.compressed )
      {
        return uncompress(f);
      }
      else
      {
        // Don't save, assume we're gonna cache that value (maybe let the user decide on this...)
        //f.data = f.input.read(f.dataSize);

        return f.input.read(f.dataSize);
      }
    }

    return f.data;
  }

  // Get a string out of a Zip Enry
  public static function getString( f:ZipEntry ):String
  {
    if ( f.data == null )
    {
      f.input.position = f.position;

      if ( f.compressed )
      {
        return uncompress(f).toString();
      }
      else
      {
        // Shortcut for uncompressed
        return f.input.readString(f.dataSize);
      }
    }
    else
    {
      return f.data.toString();
    }
  }

  public static inline function rawCompress(bytes:Bytes)
  {
    #if js
    // Haxe Deflate is currently unoptimized, use pako instead,
    // didn't want 3rd party library but it works very well so...
    var data = untyped __js__("pako.deflateRaw")(bytes.getData());
    return Bytes.ofData(data);

    #elseif lime
    return Deflate.compress(bytes);
    
    #elseif (cpp || neko)
    // Is this better than OpenFL CFFI ??? 
    // Did not test it but I would assume it's not since OpenFL don't use it...
    var data = Compress.run(bytes, 9);
    return data.sub(2,data.length-6);
    
    #elseif flash
    // Flash Native, maybe DeflateStream using Memory the proper way 
    // like it was before I change it to make it cross platform would be?
    var data = bytes.getData();
    data.deflate();
    return Bytes.ofData(data);
    
    #else
    // Pure Haxe, should work everywhere else (VERY UNOPTIMIZED!!!)
    // But allow for step by step compression, could be nice for extremely huge file?
    var deflateStream = DeflateStream.create(NORMAL);
    deflateStream.write(new BytesInput(bytes));
    
    return deflateStream.finalize();
    #end
  }

  // Compress used in PNG
  public static inline function compress(bytes:Bytes)
  {
    #if js
    // Haxe Deflate is currently unoptimized, use pako instead,
    // didn't want 3rd party library but it works very well so...
    var data = untyped __js__("pako.deflate")(bytes.getData(), {level: 9});
    return Bytes.ofData(data);

    #elseif openfl

    return format.tools.Deflate.run(bytes);
    #else

    return rawCompress(bytes);
    #end
  }
  
  // Get uncompressed bytes
  public static inline function uncompress( f:ZipEntry )
  {
    #if (lime || js || flash)
    var b = f.input.read(f.dataSize);
    return rawUncompress(b);
    
    #elseif (cpp || neko)
    var b = f.input.read(f.dataSize);
    var c = new haxe.zip.Uncompress(-15);
    var s = haxe.io.Bytes.alloc(f.fileSize);
    var r = c.execute(b,0,s,0);
    c.close();
    if ( !r.done || r.read != b.length || r.write != f.fileSize )
      throw "Invalid compressed data for "+f.fileName;
    return s;
    
    #else
    
    return rawUncompress_haxe(f.input);
    #end
  }

  public static inline function rawUncompress(bytes:Bytes):Bytes
  {
    #if lime
    return Deflate.decompress(bytes);
    
    #elseif flash
    var data = bytes.getData();
    data.inflate();
    return Bytes.ofData(data);
    
    #elseif js
    var data = untyped __js__("pako.inflateRaw")(bytes.getData());
    return Bytes.ofData(data);
    
    #else
    return rawUncompress_haxe(new BytesInput(bytes));
    #end
  }
  
  // Haxe implementation of inflate, nice fallback but doesn't seems as fast as native function...
  public static inline function rawUncompress_haxe(input:BytesInput):Bytes
  {
    var p = input.position;
    
    var bufSize = 65536;
    if ( tmp == null )
      tmp = haxe.io.Bytes.alloc(bufSize);
    var out = new haxe.io.BytesBuffer();
    var z = new InflateImpl(input, false, false);
    while ( true )
    {
      var n = z.readBytes(tmp, 0, bufSize);
      out.addBytes(tmp, 0, n);
      if ( n < bufSize )
        break;
    }
    
    input.position = p;
    
    return out.getBytes();
  }
  
  // Clean zip entry
  public static function cleanZip( f:ZipEntry )
  {
    f.data = null;
    f.fileName = null;
    f.fileTime = null;
    f.input = null;
    f.extraFields = null;
  }
  
  // Clean
  public static function clean()
  {
    buf = null;
    tmp = null;
  }
}