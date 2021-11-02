package tyd;

import tyd.nodes.TyDString;

class TyD {
	public static function main() {
		var node = new TyDString("String", "value", null);

		trace("Hello World", node.get_name());
		node.set_name("name 2");

		trace("node name", node.fullTyD);

		trace("Hello World");
	}
}
