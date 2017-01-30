package zip;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.zip.Entry;
import haxe.zip.Writer;

/**
 * Write a Zip File
 */
class ZipWriter extends Writer
{
  var output:BytesOutput;
  
  public function new() 
  {
    output = new BytesOutput();
    
    super(output);
  }
  
  // Add an existing Entry from a ZipReader (should be pretty optimized)
  public function addEntry(entry:ZipEntry):Void
  {
    writeEntryHeader(
    {
      fileName: entry.fileName,
      fileSize: entry.fileSize,
      fileTime: entry.fileTime,
      compressed: entry.compressed,
      dataSize: entry.dataSize,
      data: entry.data,
      crc32: entry.crc32,
      //extraFields: entry.extraFields // Meh... figure out why this isn't working eventually...
    });
    
    var bytes = entry.data;
    if ( bytes != null )
    {
      o.writeFullBytes(bytes, 0, bytes.length);
    }
    else
    {
      o.writeFullBytes(entry.bytes, entry.position, entry.dataSize);
    }
  }
  
  // Add a Bytes Entry
  public function addBytes(bytes:Bytes, name:String, compressed:Bool = true, date:Date = null):Void
  {
    var crc = haxe.crypto.Crc32.make(bytes);
    var data = compressed ? Zip.rawCompress(bytes) : bytes;
    
    var e:Entry = 
    {
      fileName: name,
      fileSize: bytes.length,
      fileTime: date == null ? Date.now() : date,
      compressed: compressed,
      dataSize: data.length,
      data: data,
      crc32: crc
    };
    
    writeEntryHeader(e);
    o.writeFullBytes(data, 0, data.length);
  }
  
  // Add a String Entry
  public function addString(string:String, name:String, compressed:Bool = true, date:Date = null):Void
  {
    addBytes(Bytes.ofString(string), name, compressed, date);
  }
  
  // Finalize Zip returning the Bytes
  public function finalize():Bytes
  {
    writeCDR();
    
    return output.getBytes();
  }
  
  // Allow optimization when Entry has no Data
  public override function writeEntryHeader( f : Entry ) {
		var o = this.o;
		var flags = 0;
		if (f.extraFields != null) {
			for( e in f.extraFields )
				switch( e ) {
				case FUtf8: flags |= 0x800;
				default:
				}
		}
		o.writeInt32(0x04034B50);
		o.writeUInt16(0x0014); // version
		o.writeUInt16(flags); // flags
		
    // Modification
    if( f.crc32 == null ) {
      if( f.compressed ) throw "CRC32 must be processed before compression";
      if ( f.data != null ) f.crc32 = haxe.crypto.Crc32.make(f.data);
    }
    if ( f.data != null )
    {
      if( !f.compressed )
				f.fileSize = f.data.length;
			f.dataSize = f.data.length;
    }
    
    /*if( f.data == null ) {
			f.fileSize = 0;
			f.dataSize = 0;
			f.crc32 = 0;
			f.compressed = false;
			f.data = haxe.io.Bytes.alloc(0);
		} else {
			if( f.crc32 == null ) {
				if( f.compressed ) throw "CRC32 must be processed before compression";
				f.crc32 = haxe.crypto.Crc32.make(f.data);
			}
			if( !f.compressed )
				f.fileSize = f.data.length;
			f.dataSize = f.data.length;
		}*/
    // --
    
		o.writeUInt16(f.compressed?8:0);
		writeZipDate(f.fileTime);
		o.writeInt32(f.crc32);
		o.writeInt32(f.dataSize);
		o.writeInt32(f.fileSize);
		o.writeUInt16(f.fileName.length);
		var e = new haxe.io.BytesOutput();
		if (f.extraFields != null) {
			for( f in f.extraFields )
				switch( f ) {
				case FInfoZipUnicodePath(name,crc):
					var namebytes = haxe.io.Bytes.ofString(name);
					e.writeUInt16(0x7075);
					e.writeUInt16(namebytes.length + 5);
					e.writeByte(1); // version
					e.writeInt32(crc);
					e.write(namebytes);
				case FUnknown(tag,bytes):
					e.writeUInt16(tag);
					e.writeUInt16(bytes.length);
					e.write(bytes);
				case FUtf8:
					// nothing
				}
		}
		var ebytes = e.getBytes();
		o.writeUInt16(ebytes.length);
		o.writeString(f.fileName);
		o.write(ebytes);
		files.add(
    { 
      name : f.fileName, 
      compressed : f.compressed, 
      clen : f.data != null ? f.data.length : f.dataSize, 
      size : f.fileSize, 
      crc : f.crc32, 
      date : f.fileTime, 
      fields : ebytes 
    });
	}
}