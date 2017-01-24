# haxe-zip
Library to provide a streaming Zip Reader experience and fix some issue (JS / SWF uncompress).

I'll write better example

```haxe
var entries = new StringMap<ZipEntry>();

var zip = new Zip(bytes);
var entry:ZipEntry;

// Read your Entry info (you could progressively read your zip entries X number per frame)
while ( (entry = zip.readEntryHeader()) != null )
{
  // Do something with your entry
  entries.set(entry.fileName, entry);

  trace("Entry", entry.fileName);
}

// You could get a percentage of task done using this
var percent = (entry == null) ? 1 : (zip.i.position / zip.i.length);

// Read your entry, will read the Data on request (support Deflate even on JS/SWF target)
var myBytes = Zip.getBytes(entries.get("sheets.xml"));
var myText = Zip.getString(entries.get("sheets/159288dc66df51f.xml"));

trace("Bytes", myBytes.length);
trace("Text", myText);
```