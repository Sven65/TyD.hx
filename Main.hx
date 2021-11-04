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

		// var node = new TydString("String", "value", null);
		// var collection: TydCollection = new TydCollectionImpl("Collection", null);
		// // var table: TydTable = new TydTableImpl("table", null);

		// // trace("table", table["a"]);

		// // trace(collection.lineNumber);

		// // trace("col", collection[0].name);

		// for (chr in collection) {
		// 	trace(chr);
		// }

		// for (chr in collection) {
		// 	trace(chr);
		// }

		// for (chr in collection) {
		// 	trace(chr);
		// }

		// trace("node", node.value);

		// trace("Hello World", node.name);
		// trace("node name", node.fullTyd);

		// trace("Hello World");

		// trace("is white", " ".isWhitespace());
	}
}
