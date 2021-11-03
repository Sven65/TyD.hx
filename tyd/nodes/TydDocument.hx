package tyd.nodes;

import tyd.nodes.TydCollection.TydCollectionImpl;

class TydDocument extends TydCollectionImpl {
	public function new(?nodes: Iterable<TydNode>) {
		super(null, null, -1);

		this._nodes = new Array<TydNode>();

		if (nodes != null) {
			this._nodes = Lambda.array(nodes);
		}
	}
}
