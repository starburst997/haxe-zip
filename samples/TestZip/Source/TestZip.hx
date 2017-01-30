package;

import haxe.Timer;
import haxe.ds.StringMap;

import file.load.FileLoad;
import file.save.FileSave;

import statistics.Stats;
import statistics.TraceTimer;

import zip.Zip;
import zip.ZipReader;
import zip.ZipWriter;
import zip.ZipEntry;

import haxe.io.Bytes;

// Tests
enum Tests
{
  LoadURL1;
  Save1;
  Save2;
  Compress1;
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

    var test = Save2;

    switch(test)
    {
      case LoadURL1: loadURL1();
      case Save1: save1();
      case Save2: save2();
      case Compress1: compress1();
    }
  }
  
  // Simple Save Zip test
  function save1()
  {
    trace("Save test!");
    
    var zip = new ZipWriter();
    
    trace("");
    zip.addString("Allo !!!!!!!!!!!!!! S LJDL SDJLKsljkd slakjdklj jkalsdjkl jlaksDKLJaslkjd lkaskld jasldjlkaskjd s", "allo.txt", true);
    trace("Added");
    zip.addString("Allo askjjklasdasjd laksdlasjdlasj dljasldjaskd askldkjasd", "test/allo2.txt", false);
    trace("Added");
    
    FileSave.saveClickBytes(zip.finalize(), "test.zip");
  }

  // Simple Load a Zip and Save Zip back
  function save2()
  {
    FileLoad.loadBytes(
    {
      url: TEST1,
      complete: function(bytes)
      {
        trace("Downloading complete");

        var entries = new StringMap<ZipEntry>();

        var reader = new ZipReader(bytes);
        var entry:ZipEntry;

        // Read your Entry info (you could progressively read your zip entries X number per frame)
        while ( (entry = reader.getNextEntry()) != null )
        {
          // Do something with your entry
          entries.set(entry.fileName, entry);
          
          trace("Entry", entry.fileName);
        }

        // Write ZIP
        var writer = new ZipWriter();
        for ( entry in entries.iterator() )
        {
          trace("");
          writer.addEntry(entry);
          trace("Added");
        }
        
        FileSave.saveClickBytes(writer.finalize(), "test2.zip");
      },
      error: function(error)
      {
        trace("Error", error);
      }
    });
  }
  
  // Simple Zip Compress test
  function compress1()
  {
    trace("Compress test!");
    
    var data = Bytes.ofString("Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!Atest!!!! GZIugiuGHZiuHZIuhz Allo thtest!!!! Allo thtest!!!! Allo thllo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!! Allo this is a test!!!!");
    var compressed = Zip.rawCompress( data );
    
    var uncompressed = Zip.rawUncompress(compressed);
    
    trace("Yo", compressed.length, uncompressed.length, uncompressed);
    
    // Benchmark
    /*var timer = new Timer(Std.int((1 / 60) * 1000)); // 60 FPS
    timer.run = function()
    {
      trace("");
      compressed = Zip.rawCompress( data );
      trace("Compress Time");
    };*/
    
    trace("");
    compressed = Zip.rawCompress( data );
    trace("Compress Time");
    
    trace("");
    compressed = Zip.rawCompress( data );
    trace("Compress Time");
    
    trace("");
    compressed = Zip.rawCompress( data );
    trace("Compress Time");
    
    trace("");
    compressed = Zip.rawCompress( data );
    trace("Compress Time");
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

        var zip = new ZipReader(bytes);
        var entry:ZipEntry;

        // Read your Entry info (you could progressively read your zip entries X number per frame)
        while ( (entry = zip.getNextEntry()) != null )
        {
          // Do something with your entry
          entries.set(entry.fileName, entry);

          trace("Entry", entry.fileName);
        }

        // You could get a percentage of task done using this
        var percent = (entry == null) ? 1 : zip.progress();

        // Read your entry, will read the Data on request (support Deflate even on JS target)
        var myBytes = Zip.getBytes(entries.get("sheets.xml"));
        var myText = Zip.getString(entries.get("sheets/159288dc66df51f.xml"));

        trace("Bytes", myBytes.length);
        trace("Text", myText);
        
        // Benchmark
        trace("");
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
        trace("TEST", Zip.getBytes(entries.get("sheets/159288dc66df51f.xml")).length);
      },
      error: function(error)
      {
        trace("Error", error);
      }
    });
  }
}