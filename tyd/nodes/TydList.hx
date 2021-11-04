package tyd.nodes;

import tyd.nodes.TydCollection.TydCollectionImpl;

class TydList extends TydCollectionImpl {
	public function new(name: String, parent: TydNode, docLine: Int = -1) {
		super(name, parent, docLine);
	}

	override public function deepClone(): TydNode {
		var c: TydList = new TydList(name, parent, docLine);

		copyDataFrom(c);

		return c;
	}

	public function toString(): String {
		return name + "(TydList, " + count + ")";
	}
}
