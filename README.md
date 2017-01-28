# haxe-zip
Library to provide a streaming Zip Reader experience and fix some issue (JS / SWF incompatibilities).

Mainly took zip.Reader class from haxe and did some modification.

Also took DeflateStream from [PNGEncoder2](https://github.com/cameron314/PNGEncoder2/) and removed flash specific code to add compress support on platform that did not have it natively.

I wanted a pure haxe Zip class without any 3rd party (mainly for JS).

I'll write better example

```haxe
// Uncompress example:
var entries = new StringMap<ZipEntry>();

var zip = new Zip(bytes);
var entry:ZipEntry;

// Read your Entry info (you could progressively read your zip entries X number per frame)
// Data is not copied nor uncompressed at this stage
while ( (entry = zip.readEntryHeader()) != null )
{
  // Do something with your entry
  entries.set(entry.fileName, entry);

  trace("Entry", entry.fileName);
}

// You could get a percentage of task done using this
var percent = (entry == null) ? 1 : (zip.i.position / zip.i.length);

// Read your entry, will copy the Data on request (support Deflate even on JS/SWF target)
var myBytes = Zip.getBytes(entries.get("sheets.xml"));
var myText = Zip.getString(entries.get("sheets/159288dc66df51f.xml"));

trace("Bytes", myBytes.length);
trace("Text", myText);
```