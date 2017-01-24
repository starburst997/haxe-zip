package;

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
  // List of files
  public static inline var PATH:String = "./assets/";
  public static inline var TEST1:String = PATH + "test1.zip";

  // Run some tests
  public function new()
  {
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

  }
}