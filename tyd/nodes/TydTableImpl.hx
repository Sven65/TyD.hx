package tyd.nodes;

import tyd.nodes.TydCollection.TydCollectionImpl;

@:forward
@:access(TydTableImpl)
abstract TydTable(TydTableImpl) from TydTableImpl {
	@:arrayAccess public inline function get(index: String) {
		return Lambda.find(this.nodes, item -> item.name == index);
	}
}

class TydTableImpl extends TydCollectionImpl {
	public function new(name: String, parent: TydNode, docLine: Int = -1) {
		super(name, parent, docLine);
	}

	override public function deepClone(): TydNode {
		var c: TydTableImpl = new TydTableImpl(name, parent, docLine);

		this.copyDataFrom(c);
		return c;
	}
}
