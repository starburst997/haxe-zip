package;

import openfl.display.Sprite;

/**
 * Test the Zip Library in OpenFL
 */
class MainOpenFL extends Sprite
{
  var stats:Stats = new Stats();
  var test:TestZip;

  // Run some tests
	public function new()
  {
		super();

    // Stats
    addChild(stats);

    // Test
		test = new TestZip();
	}
}