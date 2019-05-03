package zip;

import haxe.ds.StringMap;
import haxe.io.BufferInput;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.InflateImpl;
import haxe.zip.Reader;

import zip.ZipEntry;

using StringTools;

/**
 * Read a Zip File
 */
class ZipReader extends Reader
{
  public var bytes:Bytes;
  public var input:BytesInput;

  public static inline function getEntries(bytes:Bytes) {
    var entries = new StringMap<ZipEntry>();
    var zip = new ZipReader(bytes);
    var entry:ZipEntry;

    while ( (entry = zip.getNextEntry()) != null )
    {
      entries.set(entry.fileName, entry);
    }

    return entries;
  }

  public function new(bytes:Bytes) 
  {
    try {
      this.input = new BytesInput(bytes);
      this.bytes = bytes;
    } catch(e:Dynamic) {
      bytes = Bytes.alloc(128);
      this.input = new BytesInput(bytes);
      this.bytes = bytes;
    }

    super(this.input);
  }
  
  // Clean ZIP
  public function clean()
  {
    i = null;
    bytes = null;
    input = null;
  }
  
  // Get percent
  public function progress()
  {
    return input.position / input.length;
  }
  
  // Extra Fields
  function readExtra(length)
  {
    var fields = new List();
    while ( length > 0 )
    {
      if ( length < 4 ) throw "Invalid extra fields data";
      var tag = i.readUInt16();
      var len = i.readUInt16();
      if ( length < len ) throw "Invalid extra fields data";
      switch ( tag )
      {
        case 0x7075:
          var version = i.readByte();
          if ( version != 1 )
          {
            var data = new haxe.io.BytesBuffer();
            data.addByte(version);
            data.add(i.read(len-1));
            fields.add(FUnknown(tag,data.getBytes()));
          }
          else
          {
            var crc = i.readInt32();
            var name = i.read(len - 5).toString();
            fields.add(FInfoZipUnicodePath(name,crc));
          }
        default:
          fields.add(FUnknown(tag,i.read(len)));
      }
      length -= 4 + len;
    }
    return fields;
  }
  
  // Did some minor edit to allow reading the zip sequentially
  public function getNextEntry():ZipEntry
  {
    var i = this.input;
    var h = i.readInt32();
    if ( h == 0x02014B50 || h == 0x06054B50 )
      return null;
    if ( h != 0x04034B50 )
      throw "Invalid Zip Data";
    var version = i.readUInt16();
    var flags = i.readUInt16();
    var utf8 = flags & 0x800 != 0;
    if ( (flags & 0xF7F1) != 0 )
      throw "Unsupported flags "+flags;
    var compression = i.readUInt16();
    var compressed = (compression != 0);
    if ( compressed && compression != 8 )
      throw "Unsupported compression "+compression;
    var mtime = readZipDate();
    var crc32 : Null<Int> = i.readInt32();
    var csize = i.readInt32();
    var usize = i.readInt32();
    var fnamelen = i.readInt16();
    var elen = i.readInt16();
    var fname = i.readString(fnamelen);
    var fields = readExtra(elen);
    if ( utf8 )
      fields.push(FUtf8);
    var data = null;
    // we have a data descriptor that store the real crc/sizes
    // after the compressed data, let's wait for it
    if ( (flags & 8) != 0 )
      crc32 = null;

    var e:ZipEntry = {
      fileName : fname,
      fileSize : usize,
      fileTime : mtime,
      input : i,
      bytes : bytes,
      position : i.position,
      compressed : compressed,
      dataSize : csize,
      data : data,
      crc32 : crc32,
      extraFields : fields,
    };

    // Data is null, but we need to move position
    // Or if crc32 is null, then read data
    if ( e.crc32 == null )
    {
      trace("CRC32 is NULL, this is not optimal, just saying...");
      
      if ( e.compressed )
      {
        #if neko
        #if true
        trace('Currently broken?');
        #else
        // enter progressive mode : we use a different input which has
        // a temporary buffer, this is necessary since we have to uncompress
        // progressively, and after that we might have pending read data
        // that needs to be processed
        var bufSize = 65536;
        if ( buf == null )
        {
          buf = new haxe.io.BufferInput(i, haxe.io.Bytes.alloc(bufSize));
          tmp = haxe.io.Bytes.alloc(bufSize);
          i = buf;
        }
        var out = new haxe.io.BytesBuffer();
        var z = new neko.zip.Uncompress(-15);
        z.setFlushMode(neko.zip.Flush.SYNC);
        while ( true )
        {
          if ( buf.available == 0 )
            buf.refill();
          var p = bufSize - buf.available;
          if ( p != buf.pos )
          {
            // because of lack of "srcLen" in zip api, we need to always be stuck to the buffer end
            buf.buf.blit(p, buf.buf, buf.pos, buf.available);
            buf.pos = p;
          }
          var r = z.execute(buf.buf, buf.pos, tmp, 0);
          out.addBytes(tmp, 0, r.write);
          buf.pos += r.read;
          buf.available -= r.read;
          if ( r.done ) break;
        }
        e.data = out.getBytes();
        #end
        #else
        e.data = Zip.rawUncompress_haxe(i);
        #end

        // This is the only case where we do read the data anyway...
        // Why would the crc32 be null?
        //trace("crc32 is null and compressed!");
      }
      else
      {
        //trace("crc32 is null but uncompressed!");
        // Keep data null, skip position
        i.position += e.dataSize;
        //e.data = i.read(e.dataSize);
      }

      e.crc32 = i.readInt32();
      if ( e.crc32 == 0x08074b50 )
        e.crc32 = i.readInt32();
      e.dataSize = i.readInt32();
      e.fileSize = i.readInt32();
      // set data to uncompressed
      e.dataSize = e.fileSize;
      e.compressed = false;
    }
    else
    {
      //trace("crc32 is not null!");
      // Keep data null, skip position
      i.position += e.dataSize;
    }

    // Skip Folder
    if ( e.fileName.endsWith("/") )
    {
      return getNextEntry();
    }
    
    return e;
  }
}