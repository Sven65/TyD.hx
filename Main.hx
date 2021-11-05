package;

import haxe.Exception;
import tyd.TydFromText;
import tyd.nodes.TydCollection;
import tyd.nodes.TydList;
import tyd.nodes.TydString;
import tyd.nodes.TydTableImpl.TydTable;
import tyd.nodes.TydTableImpl;

using tyd.util.StringExtensions;

// import tyd.nodes.TydTable;
class Main {
	public static function main() {
		var content = sys.io.File.getContent('./__test__/GameData.tyd');

		try {
			var parsed = TydFromText.parse(content);
			trace("count", parsed.length);

			for (node in parsed) {
				trace(node.fullTyd);
			}

			// trace(parsed[1].fullTyd);

			// var table: TydTable = cast(parsed[0], TydTableImpl);

			// trace("name", cast(table["name"], TydString).value);
		}
		catch (e:Exception) {
			trace("error", e);
		}
	}
}
