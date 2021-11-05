package tyd.nodes;

import tyd.nodes.TydCollection.TydCollectionImpl;

@:forward
@:access(TydListImpl)
abstract TydList(TydListImpl) from TydListImpl {
	@:arrayAccess public inline function get(index: Int) {
		return this.nodes[index];
	}
}

class TydListImpl extends TydCollectionImpl {
	public function new(name: String, parent: TydNode, docLine: Int = -1) {
		super(name, parent, docLine);
	}

	override public function deepClone(): TydNode {
		var c: TydListImpl = new TydListImpl(name, parent, docLine);

		copyDataFrom(c);

		return c;
	}

	public function toString(): String {
		return name + "(TydList, " + count + ")";
	}
}
