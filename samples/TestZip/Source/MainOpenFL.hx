package;

import openfl.display.Sprite;

/**
 * Test the Zip Library in OpenFL
 */
class MainOpenFL extends Sprite
{
  var test:TestZip;

  // Run some tests
	public function new()
  {
		super();

    // Test
		test = new TestZip();
	}
}