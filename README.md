# haxe-zip
Library to provide a streaming Zip Reader experience and fix some issue (JS uncompress).

I'll write better example

```haxe
var zip = new Zip(bytes);
var entry:ZipEntry;

// Read your Entry info (you could progressively read your zip entries X number per frame)
while ( (entry = zip.readEntryHeader()) != null )
{
  // Do something with your entry
  entries[entry.fileName] = entry;
}

// You could get a percentage of task done using this
var percent = (entry == null) ? 1 : (zip.i.position / zip.i.length);

// Read your entry, will read the Data on request (support Deflate even on JS target)
var myBytes = Zip.getBytes(entries["image.png"]);
var myText = Zip.getString(entries["info.json"]);
```