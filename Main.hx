package;

import tyd.nodes.TydCollection;
import tyd.nodes.TydString;

// import tyd.nodes.TydTable;
class Main {
	public static function main() {
		var node = new TydString("String", "value", null);
		var collection: TydCollection = new TydCollectionImpl("Collection", null);
		// var table: TydTable = new TydTableImpl("table", null);

		// trace("table", table["a"]);

		// trace(collection.lineNumber);

		// trace("col", collection[0].name);

		for (chr in collection) {
			trace(chr);
		}

		for (chr in collection) {
			trace(chr);
		}

		for (chr in collection) {
			trace(chr);
		}

		trace("node", node.value);

		trace("Hello World", node.name);
		trace("node name", node.fullTyd);

		trace("Hello World");
	}
}
