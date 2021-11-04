package tyd;

import haxe.Exception;
import haxe.iterators.StringIterator;
import tyd.nodes.TydList;
import tyd.nodes.TydNode;
import tyd.nodes.TydString;
import tyd.nodes.TydTableImpl;
import tyd.util.RefInt;
import tyd.util.Types.LineColumnStruct;

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
	public static function parse(text: String): Array<TydNode> {
		return Parse(text, 0, null, true);
	}

	private static function Parse(text: String, startIndex: Int, parent: TydNode, expectNames: Bool = true): Array<TydNode> {
		var parsedNodes: Array<TydNode> = new Array<TydNode>();

		var p: RefInt = startIndex;

		// Main loop
		while (p != text.length) {
			var recordName: String = null;
			var recordAttHandle: String = null;
			var recordAttSource: String = null;
			var recordAttAbstract: Bool = false;
			var recordAttNoInherit: Bool = false;

			try {
				// Skip insubstantial chars
				p = nextSubstanceIndex(text, p);

				// We reached EOF, we're finished
				if (p == text.length) {
					if (parent != null) {
						throw new Exception("Missing closing brackets");
					}

					break;
				}

				// We reached a closing bracket, so we're finished with this record
				if (text.charAt(p) == Constants.TableEndChar || text.charAt(p) == Constants.ListEndChar)
					break;

				// Read the record name if we're not reading anonymous records
				if (expectNames) {
					recordName = readSymbol(text, SymbolType.RecordName, p);
				}

				// Skip whitespace
				p = nextSubstanceIndex(text, p);

				// Read attributes
				while (text.charAt(p) == Constants.AttributeStartChar) {
					// Skip past the '*' character
					p++;

					// Read the att name

					var attName: String = readSymbol(text, SymbolType.AttributeName, p);
					if (attName == Constants.AbstractAttributeName) {
						// Just reading the abstract name indicates it's abstract, no value is needed
						recordAttAbstract = true;
					}
					else if (attName == Constants.NoInheritAttributeName) {
						// Just reading the noinherit name indicates it's noinherit, no value is needed
						recordAttNoInherit = true;
					}
					else {
						p = nextSubstanceIndex(text, p);

						// Read the att value

						var attVal: String = readSymbol(text, SymbolType.AttributeValue, p);
						switch (attName) {
							case Constants.HandleAttributeName:
								recordAttHandle = attVal;
							case Constants.SourceAttributeName:
								recordAttSource = attVal;
							default:
								throw new Exception("Unknown attribute name '" + attName + "' at " + lineColumnString(text, p) + "\n"
									+ errorSectionString(text, p));
						}
					}

					p = nextSubstanceIndex(text, p);
				}
			}
			catch (e:Exception) {
				throw new Exception("Exception parsing Tyd headers at " + lineColumnString(text,
					p) + ": " + e.toString() + "\n" + errorSectionString(text, p), e);
			}

			// Read the record value.
			// After this is complete, p should be pointing at the char after the last char of the record.
			if (text.charAt(p) == Constants.TableStartChar) {
				// It's a table

				var newTable: TydTable = new TydTableImpl(recordName, parent, indexToLine(text, p));

				// Skip past the opening bracket
				p++;

				p = nextSubstanceIndex(text, p);

				// Recursively parse all of new child's children
				for (subNode in Parse(text, p, cast newTable, true)) {
					newTable.addChild(subNode);
					p = subNode.docIndexEnd + 1;
				}

				p = nextSubstanceIndex(text, p);

				// Confirm that we are indeed on the closing bracket
				if (text.charAt(p) != Constants.TableEndChar) {
					throw new Exception("Expected '" + Constants.TableEndChar + "' at " + lineColumnString(text, p) + "\n" + errorSectionString(text, p));
					break;
				}

				newTable.docIndexEnd = p;
				newTable.setupAttributes(recordAttHandle, recordAttSource, recordAttAbstract, recordAttNoInherit);

				parsedNodes.push(cast newTable);

				// Move pointer one past the closing bracket
				p++;
			}
			else if (text.charAt(p) == Constants.ListStartChar) {
				// It's a list
				var newList: TydList = new TydList(recordName, parent, indexToLine(text, p));

				// Skip past the opening bracket
				p++;

				p = nextSubstanceIndex(text, p);

				// Recursively parse all of new child's children and add them to it
				for (subNode in Parse(text, p, newList, false)) {
					newList.addChild(subNode);
					p = subNode.docIndexEnd + 1;
				}
				p = nextSubstanceIndex(text, p);
				if (text.charAt(p) != Constants.ListEndChar) {
					throw new Exception("Expected " + Constants.ListEndChar + " at " + lineColumnString(text, p) + "\n" + errorSectionString(text, p));
				}

				newList.docIndexEnd = p;
				newList.setupAttributes(recordAttHandle, recordAttSource, recordAttAbstract, recordAttNoInherit);

				parsedNodes.push(newList);

				// Move pointer one past the closing bracket
				p++;
			}
			else {
				// It's a string
				var pStart: Int = p;
				var val: String;
				val = parseStringValue(text, p);

				var strNode: TydString = new TydString(recordName, val, parent, indexToLine(text, pStart));
				strNode.docIndexEnd = p - 1;

				parsedNodes.push(strNode);
			}
		}

		return parsedNodes;
	}

	// We are at the first char of a string value of unknown type.
	// This returns the string value, and places p at the first char after it.

	private static function parseStringValue(text: String, p: RefInt): String {
		var val: String;
		var format: StringFormat;
		switch (text.charAt(p)) {
			case '"':
				format = StringFormat.Quoted;
			case '|':
				format = StringFormat.Vertical;
			default:
				format = StringFormat.Naked;
		}
		// Parse as a quoted string
		if (format == StringFormat.Quoted) {
			p++; // Move past the opening quote
			var pStart: Int = p;
			// Walk forward until we find the end quote
			// We need to ignore any that are escaped
			while (p < text.length && !(text.charAt(p) == '"' && text.charAt(p - 1) != '\\'))
				p++;
			// Set the return value to the contents of the string
			val = text.substring(pStart, p - pStart);
			val = resolveEscapeChars(val);
			// Move past the end quote so we're pointing just after it
			p++;

			return val;
		}
		else if (format == StringFormat.Vertical) {
			var sbVal: String = '';
			// Line-processing loop
			while (true) {
				p++; // Move past vbar at line start
				var lineContentStart: Int = p;
				// Find next end of document or EOL
				while (p < text.length && !isNewline(text, p)) {
					p++;
				}
				// p is now pointing at the first EOL char, or just after document end
				// Add the content of this line to the string
				sbVal += (text.substring(lineContentStart, p - lineContentStart));
				// Skip past EOL and whitespace
				p = nextSubstanceIndex(text, p);
				// If the first substance we hit is a vbar, our string continues.
				// Otherwise, it ends
				if (p < text.length && text.charAt(p) == '|') {
					sbVal += StringExtensions.lineEnd;
					continue;
				}
				else {
					return sbVal;
				}
			}
		}
		else if (format == StringFormat.Naked) {
			var pStart: Int = p;

			// Walk forward until we're on the first string content-terminating char or char group
			// We need to ignore any that are escaped
			while (p < text.length
				&& !isNewline(text, p)
				&& !((text.charAt(p) == Constants.RecordEndChar
					|| text.charAt(p) == Constants.CommentChar
					|| text.charAt(p) == Constants.TableEndChar
					|| text.charAt(p) == Constants.ListEndChar)
					&& text.charAt(p - 1) != '\\'))
				p++;
			// We are now pointing at the first char after the string value.
			// However, we now need to remove whitespace after the value.
			// So we make pointer q, and walk it backwards until it's on non-whitespace.
			// This lets us find the last non-whitespace char of the string value.
			var q: Int = p - 1;

			while (text.charAt(q).isWhitespace())
				q--;

			val = text.substring(pStart, q - pStart + 1);

			if (val == "null") // Special case for 'null' naked string.
				val = null;
			else
				val = resolveEscapeChars(val);

			return val;
		}
		else
			throw new Exception("");
	}

	/**
	 * Take the input string and replace any escape sequences with the final chars they correspond to.
	 * This can be opimized
	 * @param input 
	 * @return String
	 */
	private static function resolveEscapeChars(input: String): String {
		for (k in 0...input.length) {
			if (input.charAt(k) == '\\') {
				if (input.length <= k + 1)
					throw new Exception("Tyd string value ends with single backslash: " + input);

				var resolvedChar: String = escapedCharOf(input.charAt(k + 1));
				input = input.substring(0, k) + resolvedChar + input.substring(k + 2);
			}
		}
		return input;
	}

	// Returns the character that an escape sequence should resolve to, based on the second char of the escape sequence (after the backslash).
	private static function escapedCharOf(inputChar: String): String {
		switch (inputChar) {
			case '\\':
				return '\\';
			case '"':
				return '"';
			case '#':
				return '#';
			case ';':
				return ';';
			case ']':
				return ']';
			case '}':
				return '}';
			case '\r':
				return '\u000D';
			case 'n':
				return '\u000A';
			case 't':
				return '\u0009';
			default:
				throw new Exception("Cannot escape char: \\" + inputChar);
		}
	}

	private static function readSymbol(text: String, symType: SymbolType, p: RefInt): String {
		var pStart: Int = p;
		while (true) {
			var c = text.charAt(p);

			if (c.isWhitespace())
				break;
			if (!isSymbolChar(c))
				break;
			p++;
		}
		if (p == pStart) {
			throw new Exception("Expected " + symbolTypeName(symType) + " at " + lineColumnString(text, p) + "\n" + errorSectionString(text, p));
		}
		return text.substring(pStart, p - pStart);
	}

	private static function symbolTypeName(st: SymbolType): String {
		switch (st) {
			case SymbolType.RecordName:
				return "record name";
			case SymbolType.AttributeName:
				return "attribute name";
			case SymbolType.AttributeValue:
				return "attribute value";
			default:
				throw new Exception("");
		}
	}

	private static function isSymbolChar(c: String): Bool {
		// This can be optimized to a range check

		for (chr in new StringIterator(Constants.SymbolChars)) {
			if (chr == c.charCodeAt(0))
				return true;
		}
		return false;
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

	private static function lineColumnString(text: String, index: Int): String {
		var line = -1, col: Int = -1;
		var lineColumn = indexToLineColumn(text, index);

		line = lineColumn.line;
		col = lineColumn.column;

		return "line " + line + ", col " + col;
	}

	private static function errorSectionString(text: String, index: Int): String {
		var CharRangeWidth: Int = 500;
		var modText: String = text;

		modText.insert(Std.int(Math.min(index, text.length - 1)), "[ERROR]");

		if (index > CharRangeWidth || text.length > index + CharRangeWidth) {
			var start: Int = Std.int(Math.max(index - CharRangeWidth, 0));

			var length: Int = Std.int(Math.min(CharRangeWidth * 2, text.length - index));
			text = text.substring(start, length);
		}
		return modText;
	}

	private static function indexToLine(text: String, index: Int): Int {
		var line: Int = -1;
		var lineColumn = indexToLineColumn(text, index);

		line = lineColumn.line;

		return line;
	}

	private static function indexToLineColumn(text: String, index: Int): LineColumnStruct {
		// Note that these start at 1, not 0, because normal people are supposed to be able to use these
		var line: Int = 1;
		var column: Int = 1;

		var p = 0;

		while (p < index) {
			p++;
			if (isNewlineLF(text, p)) {
				line++;
				column = 0;
			}
			else if (isNewlineCRLF(text, p)) {
				line++;
				column = 0;
				p++; // Skip forward an extra
			}
			column++;
		}

		return {
			line: line,
			column: column,
		}
	}

	/**
	 * Returns the index off the next char after p that is not whitespace or part of a comment.
	 * If there is no more substance in the text, this returns an index just after the end of the text.
	 * @param text
	 * @param p 
	 * @return Int
	 */
	private static function nextSubstanceIndex(text: String, p: RefInt): Int {
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
