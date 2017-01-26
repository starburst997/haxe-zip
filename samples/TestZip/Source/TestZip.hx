package;

import haxe.ds.StringMap;
import multiloader.MultiLoader;
import statistics.Stats;
import trace.TraceTimer;

import zip.Zip;
import zip.ZipEntry;

// Tests
enum Tests
{
  LoadURL1;
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

    var test = LoadURL1;

    switch(test)
    {
      case LoadURL1: loadURL1();
    }
  }

  // Simply load a URL and do nothing else
  function loadURL1()
  {
    MultiLoader.loadBytes(
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