# haxe-zip
Library to provide a cross-platform streaming Zip Writer / Reader experience.

Mainly took haxe.zip.* class from haxe and did some modification.

Also took DeflateStream from [PNGEncoder2](https://github.com/cameron314/PNGEncoder2/) and removed flash specific code to add compress support on platform that did not have it natively.

Use pako.js for JS target (sadly although DeflateStream works, it's not optimized)

On flash, use deflate / inflate from ByteArray

If OpenFL is detected then we use lime functions for Compress / Decompress

Pretty much every targets should be compatible with this library although I only tested SWF / JS / OpenFL

I'll write better example eventually

```haxe
// Compress example:
var zip = new ZipWriter();

zip.addString("This is a compressed text file", "hey.txt", true);
zip.addString("This is a non-compressed text file", "test/you.txt", false);

var bytes = zip.finalize();
```

```haxe
// Uncompress example:
var entries = new StringMap<ZipEntry>();

var zip = new ZipReader(bytes);
var entry:ZipEntry;

// Read your Entry info (you could progressively read your zip entries X number per frame)
// Data is not copied nor uncompressed at this stage
while ( (entry = zip.getNextEntry()) != null )
{
  // Do something with your entry
  entries.set(entry.fileName, entry);

  trace("Entry", entry.fileName);
}

// You could get a percentage of task done using this
var percent = (entry == null) ? 1 : zip.progress();

// Read your entry's data, will copy the Data on request (support Deflate even on JS/SWF target)
var myBytes = Zip.getBytes(entries.get("sheets.xml"));
var myText = Zip.getString(entries.get("sheets/159288dc66df51f.xml"));

trace("Bytes", myBytes.length);
trace("Text", myText);
```