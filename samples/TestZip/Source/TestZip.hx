package;

import haxe.ds.StringMap;

import file.load.FileLoad;

import statistics.Stats;
import statistics.TraceTimer;

import zip.Zip;
import zip.ZipEntry;

import haxe.io.Bytes;

// Tests
enum Tests
{
  LoadURL1;
  Save1;
}

/**
 * Class used to Test Zip Library
 *
 * Install https://github.com/tapio/live-server and start from html5 folder
 * Simply issue "live-server" inside the html5 folder and build (release for faster build)
 * Server will reload page automatically when JS is compiled
 */
class TestZip
{
  // Stats
  var stats:Stats = new Stats();

  // List of files
  public static inline var PATH:String = "./assets/";
  public static inline var TEST1:String = PATH + "test1.zip";

  // Run some tests
  public function new()
  {
    TraceTimer.activate();

    trace("TestZip Launch");

    var test = Save1;

    switch(test)
    {
      case LoadURL1: loadURL1();
      case Save1: save1();
    }
  }

  // Simple Zip Write test
  function save1()
  {
    trace("Save test!");
    
    var data = Bytes.ofString("Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!");
    var compressed = Zip.rawCompress( data );
    
    var uncompressed = Zip.rawUncompress(compressed);
    
    trace("Yo", compressed.length, uncompressed.length, uncompressed);
    
    
    trace("Compress Time");
    compressed = Zip.rawCompress( data );
    trace("Compress Time");
    compressed = Zip.rawCompress( data );
    trace("Compress Time");
    compressed = Zip.rawCompress( data );
    trace("Compress Time");
    compressed = Zip.rawCompress( data );
    trace("Compress Time");
    compressed = Zip.rawCompress( data );
  }
  
  // Simply load a URL and do nothing else
  function loadURL1()
  {
    FileLoad.loadBytes(
    {
      url: TEST1,
      complete: function(bytes)
      {
        trace("Downloading complete");

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

        // Read your entry, will read the Data on request (support Deflate even on JS target)
        var myBytes = Zip.getBytes(entries.get("sheets.xml"));
        var myText = Zip.getString(entries.get("sheets/159288dc66df51f.xml"));

        trace("Bytes", myBytes.length);
        trace("Text", myText);
      },
      error: function(error)
      {
        trace("Error", error);
      }
    });
  }
}