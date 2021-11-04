package;

import haxe.Exception;
import tyd.TydFromText;
import tyd.nodes.TydCollection;
import tyd.nodes.TydString;
import tyd.nodes.TydTableImpl.TydTable;

using tyd.util.StringExtensions;

// import tyd.nodes.TydTable;
class Main {
	public static function main() {
		var content = sys.io.File.getContent('./__test__/GameData.tyd');

		try {
			var parsed = TydFromText.parse(content);
			trace("count", parsed.length);

			for (node in parsed) {
				trace("node", node.name);
			}

			// var table: TydTable = cast parsed[0];

			// trace("name", table.get("name"));
		}
		catch (e:Exception) {
			trace("error", e);
		}
	}
}
