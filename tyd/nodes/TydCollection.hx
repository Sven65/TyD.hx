package tyd.nodes;

@:forward
@:access(TydCollectionImpl)
abstract TydCollection(TydCollectionImpl) from TydCollectionImpl {
	@:arrayAccess public inline function get(index: Int) {
		return this.nodes[index];
	}
}

class TydCollectionImpl extends TydNode {
	private var _nodes: Array<TydNode>;
	private var attHandle: String;
	private var attSource: String;
	private var attAbstract: Bool;
	private var attNoInherit: Bool;

	public var count(get, null): Int;
	public var nodes(get, null): Array<TydNode>;
	public var attributeHandle(get, set): String;
	public var attributeSource(get, set): String;
	public var attributeAbstract(get, set): Bool;
	public var attributeNoInherit(get, set): Bool;

	public function new(name: String, parent: TydNode, docLine: Int = -1) {
		super(name, parent, docLine);

		this._nodes = new Array<TydNode>();
	}

	public function setupAttributes(attHandle: String, attSource: String, attAbstract: Bool, attNoInherit: Bool) {
		this.attHandle = attHandle;
		this.attSource = attSource;
		this.attAbstract = attAbstract;
		this.attNoInherit = attNoInherit;
	}

	public function addChild(node: TydNode) {
		_nodes.push(node);

		node.parent = this;
	}

	public function insertChild(node: TydNode, index: Int) {
		_nodes.insert(index, node);
		node.parent = this;
	}

	public function deepClone(): TydNode {
		return this;
	}

	public function iterator() {
		return _nodes.iterator();
	}

	function copyDataFrom(other: TydCollection) {
		other.docIndexEnd = docIndexEnd;
		other.attHandle = attHandle;
		other.attSource = attSource;
		other.attAbstract = attAbstract;
		other.attNoInherit = attNoInherit;
		for (i in 0..._nodes.length) {
			other.addChild(nodes[i].deepClone());
		}
	}

	function get_count(): Int {
		return _nodes.length;
	}

	function get_nodes(): Array<TydNode> {
		return _nodes;
	}

	function get_attributeHandle(): String {
		return attHandle;
	}

	function set_attributeHandle(value: String): String {
		return attHandle = value;
	}

	function get_attributeSource(): String {
		return attSource;
	}

	function set_attributeSource(value: String): String {
		return attSource = value;
	}

	function get_attributeAbstract(): Bool {
		return attAbstract;
	}

	function set_attributeAbstract(value: Bool): Bool {
		return attAbstract = value;
	}

	function get_attributeNoInherit(): Bool {
		return attNoInherit;
	}

	function set_attributeNoInherit(value: Bool): Bool {
		return attNoInherit = value;
	}
}
