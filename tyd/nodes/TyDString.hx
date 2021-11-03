package tyd.nodes;

class TydString extends TydNode {
	public var value: String;

	public function new(name: String, value: String, parent: TydNode, docLine: Int = -1) {
		super(name, parent, docLine);

		this.value = value;
	}

	public function deepClone() {
		var c: TydString = new TydString(name, value, parent, docLine);
		c.docIndexEnd = docIndexEnd;
		return c;
	}
}
