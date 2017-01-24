package;

/**
 * Class used to Test Zip Library
 *
 * Install https://github.com/tapio/live-server and start from html5 folder
 * Simply issue "live-server" inside the html5 folder and build (release for faster build)
 * Server will reload page automatically when JS is compiled
 */
class Main
{
  var test:TestZip;

  public function new()
  {
    test = new DebugPlayer();
  }

  static function main()
  {
    new Main();
  }
}