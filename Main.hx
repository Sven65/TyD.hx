package;

import haxe.Exception;
import tyd.TydFromText;
import tyd.nodes.TydCollection;
import tyd.nodes.TydString;

using tyd.util.StringExtensions;

// import tyd.nodes.TydTable;
class Main {
	public static function main() {
		var content = sys.io.File.getContent('./__test__/GameData.tyd');

		try {
			var parsed = TydFromText.parse(content);
			trace("count", parsed.length);

			for (node in parsed) {
				trace("node", node);
			}
		}
		catch (e:Exception) {
			trace(e);
		}
	}
}
