package tyd.nodes;

class TyDString extends TyDNode {
	private var val: String;

	public function new(name: String, val: String, parent: TyDNode, docLine: Int = -1) {
		super(name, parent, docLine);

		this.val = val;
	}

	public function deepClone() {
		var c: TyDString = new TyDString(name, val, parent, docLine);
		c.docIndexEnd = docIndexEnd;
		return c;
	}
}
