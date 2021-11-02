package tyd.nodes;

enum NodeType {
	STRING;
	TABLE;
	DOCUMENT;
	LIST;
}

abstract class TyDNode {
	@:isVar private var parent(get, set): TyDNode;

	/**
	 * Can be null for anonymous nodes
	 */
	@:isVar private var name: String;

	/**
	 * Line in the doc where this node starts
	 */
	@:isVar public var docLine: Int = -1;

	/**
	 * Index in the doc where this node ends
	 */
	@:isVar public var docIndexEnd: Int = -1;

	public var fullTyD(get, null): String;

	public function get_parent() {
		return parent;
	}

	public function set_parent(node: TyDNode): TyDNode {
		return this.parent = node;
	}

	public function get_name() {
		return name;
	}

	public function set_name(name: String): String {
		return this.name = name;
	}

	public function get_fullTyD(): String {
		return "This is tyd";
	}

	public function new(name: String, parent: TyDNode, docLine: Int = -1) {
		this.parent = parent;
		this.name = name;
		this.docLine = docLine;
	}

	public abstract function deepClone(): TyDNode;
}
