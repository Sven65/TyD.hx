package tyd.nodes;

enum NodeType {
	STRING;
	TABLE;
	DOCUMENT;
	LIST;
}

abstract class TydNode {
	@:isVar public var parent(get, set): TydNode;

	/**
	 * Can be null for anonymous nodes
	 */
	@:isVar public var name(get, null): String;

	/**
	 * Line in the doc where this node starts
	 */
	private var docLine: Int = -1;

	public var lineNumber(get, null): Int;

	/**
	 * Index in the doc where this node ends
	 */
	@:isVar public var docIndexEnd: Int = -1;

	public var fullTyd(get, null): String;

	private function get_parent() {
		return parent;
	}

	private function set_parent(node: TydNode): TydNode {
		return this.parent = node;
	}

	private function get_name() {
		return name;
	}

	private function get_lineNumber() {
		return docLine;
	}

	private function get_fullTyd(): String {
		return "This is tyd";
	}

	public function new(name: String, parent: TydNode, docLine: Int = -1) {
		this.parent = parent;
		this.name = name;
		this.docLine = docLine;
	}

	public abstract function deepClone(): TydNode;
}
