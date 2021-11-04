// This is one big ugly hack in order to pass ints by reference, because I'm lazy.
package tyd.util;

import haxe.Exception;

typedef WrappedInt = {
	val: Int,
}

abstract RefInt(WrappedInt) {
	public function new(i: Int) {
		this = {
			val: i,
		};
	}

	@:from
	static public function fromInt(i: Int) {
		return new RefInt(i);
	}

	@:to
	public function toInt() {
		return this.val;
	}

	@:op(A++)
	public inline function postincrement(): Int {
		this.val++;
		return this.val;
	}

	@:op(A - B)
	public inline function subtract(rhs: Int): Int {
		//  IMPLEMENTATION
		return this.val - rhs;
	}

	@:op(A < B)
	public static function lt(lhs: RefInt, rhs: Int): Bool {
		//  IMPLEMENTATION
		return lhs.toInt() < rhs;
	}

	@:op(A >= B)
	public static function gtequals(lhs: RefInt, rhs: Int): Bool {
		return !(lhs < rhs);
	}

	@:op(A += B)
	public inline function addassign(rhs: Int): Int {
		//  IMPLEMENTATION

		this.val += rhs;

		return this.val;
	}

	@:op(A == B)
	public static function equals(lhs: RefInt, rhs: Int): Bool {
		//  IMPLEMENTATION

		return lhs.toInt() == rhs;
	}
}
