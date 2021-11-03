package tyd;

import haxe.Exception;
import tyd.nodes.TydNode;

using tyd.util.StringExtensions;

enum SymbolType {
	RecordName;
	AttributeName;
	AttributeValue;
}

enum StringFormat {
	Naked;
	Quoted;
	Vertical;
}

class TydFromText {
	public static function parse(text: String): Iterable<TydNode> {
		return Parse(text, 0, null, true);
	}

	private static function Parse(text: String, startIndex: Int, parent: TydNode, expectNames: Bool = true): Iterable<TydNode> {
		var p: Int = startIndex;

		// Main loop
		while (true) {
			var recordName: String = null;
			var recordAttHandle: String = null;
			var recordAttSource: String = null;
			var recordAttAbstract: Bool = false;
			var recordAttNoInherit: Bool = false;

			try {
				// Skip insubstantial chars
				p = nextSubstanceIndex(text, p);
			}
		}
	}

	private static function isNewline(text: String, p: Int): Bool {
		return isNewlineLF(text, p) || isNewlineCRLF(text, p);
	}

	private static function isNewlineLF(text: String, p: Int): Bool {
		return text.charAt(p) == '\n';
	}

	private static function isNewlineCRLF(text: String, p: Int): Bool {
		return text.charAt(p) == '\r' && p < text.length - 1 && text.charAt(p + 1) == '\n';
	}

	/**
	 * Returns the index off the next char after p that is not whitespace or part of a comment.
	 * If there is no more substance in the text, this returns an index just after the end of the text.
	 * @param text
	 * @param p 
	 * @return Int
	 */
	private static function nextSubstanceIndex(text: String, p: Int): Int {
		// Skip forward as long as p keeps hitting insubstantial chars or char groups

		// Skip forward as long as p keeps hitting insubstantial chars or char groups
		while (true) {
			// Reached end of text - return an index just after text end
			if (p >= text.length)
				return text.length;

			// It's whitespace - skip over it
			if (text.charAt(p).isWhitespace()) {
				p++;
				continue;
			}

			// It's the end of an empty record - skip over it
			if (text.charAt(p) == Constants.RecordEndChar) {
				p++;
				continue;
			}

			// It's the start of a comment - skip to the next line
			if (text.charAt(p) == Constants.CommentChar) {
				while (p < text.length && !isNewline(text, p))
					p++;

				// We got to the end of the document (last line was a comment)
				if (p == text.length)
					return p;

				// Skip past newline char(s)
				if (isNewlineLF(text, p))
					p += 1;
				else if (isNewlineCRLF(text, p))
					p += 2;
				else
					throw new Exception("Parsing error");

				continue;
			}

			// It's not any of the above cases, so it's a substance char
			return p;
		}
	}
}
