package tyd.util;

class StringExtensions {
	private static var spaceSeparator: String = "\u0020\u00A0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000";
	private static var lineSeparator: String = "\u2028";
	private static var paragraphSeparator: String = "\u2029";
	private static var characterTabulation: String = "\u0009\u000A\u000B\u000C\u000D\u0085";

	static public var lineEnd(get, null): String;

	static public function isWhitespace(char: String): Bool {
		var spaces = spaceSeparator.split("");
		var tabulations = characterTabulation.split("");

		return char == lineSeparator || char == paragraphSeparator || spaces.contains(char) || tabulations.contains(char);
	}

	static public function insert(original: String, pos: Int, text: String): String {
		var startString = original.substr(0, pos);
		var endString = original.substring(3);
		return '$startString$text$endString';
	}

	static function get_lineEnd(): String {
		#if target.sys
		return switch (Sys.systemName()) {
			case "Mac": "\r";
			case "Linux": "\n";
			case _: "\r\n";
		}
		#else
		return "\r\n";
		#end
	}
}
