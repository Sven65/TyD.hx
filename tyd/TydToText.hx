package tyd;

import haxe.Exception;
import tyd.nodes.TydCollection;
import tyd.nodes.TydList;
import tyd.nodes.TydNode;
import tyd.nodes.TydString;
import tyd.nodes.TydTableImpl;
import tyd.util.MultiReturn;
import tyd.util.StringExtensions;

using StringTools;

class TydToText {
	/**
	 * Converts a TydNode into text
	 * @param node The node to convert
	 * @param indent The indent level.
	 * @return String
	 */
	public static function write(node: TydNode, indent: Int = 0): String {
		if (Std.isOfType(node, TydString)) {
			return indentString(indent) + node.name + " " + stringContentWriteable(cast(node, TydString).value);
		}

		if (Std.isOfType(node, TydTableImpl)) {
			var sb: String = "";
			var tab: TydTable = cast(node, TydTable);

			// Intro line

			var nodeIntro = appendNodeIntro(cast tab, sb, indent);

			if (nodeIntro.val1 && tab.count > 0) {
				sb += StringExtensions.lineEnd;
				sb += nodeIntro.val2;
			}

			if (tab.count == 0) {
				sb += Constants.TableStartChar + Constants.TableEndChar;
			}
			else {
				// Sub-nodes
				sb += StringExtensions.lineEnd + indentString(indent) + Constants.TableStartChar;
				for (i in 0...tab.count) {
					sb += StringExtensions.lineEnd + write(tab[i], indent + 1);
				}
				sb += indentString(indent) + Constants.TableEndChar;
			}

			return sb;
		}

		if (Std.isOfType(node, TydListImpl)) {
			var sb: String = "";
			var list: TydList = cast(node, TydList);

			// Intro line
			var nodeIntro = appendNodeIntro(cast list, sb, indent);

			if (nodeIntro.val1 && list.count > 0) {
				sb += StringExtensions.lineEnd;
				sb += nodeIntro.val2;
			}

			if (list.count == 0)
				sb += Constants.ListStartChar + Constants.ListEndChar;
			else {
				// Sub-nodes
				sb += StringExtensions.lineEnd + indentString(indent) + Constants.ListStartChar;
				for (i in 0...list.count) {
					sb += StringExtensions.lineEnd + write(list[i], indent + 1);
				}
				sb += indentString(indent) + Constants.ListEndChar;
			}

			return sb;
		}

		throw new Exception("Format error");
		return null;
	}

	private static function stringContentWriteable(value: String): String {
		if (value == "")
			return "\"\"";
		if (value == null)
			return Constants.NullValueString;
		return shouldWriteWithQuotes(value) ? "\"" + escapeCharsEscapedForQuotedString(value) + "\"" : value;
	}

	// This is a set of heuristics to try to determine if we should write a string quoted or naked.
	private static function shouldWriteWithQuotes(s: String): Bool {
		if (s.length > 40) // String is long
			return true;

		if (s.charAt(s.length - 1) == '.') // String ends with a period. It's probably a sentence
			return true;

		// Check the string character-by-character
		for (i in 0...s.length) {
			var c = s.charAt(i);

			// Chars that imply we should use quotes
			// Some of these are heuristics, like space.
			// Some absolutely require quotes, like the double-quote itself. They'll break naked strings if unescaped (and naked strings are always written unescaped).
			// Note that period is not on this list; it commonly appears as a decimal in numbers.
			if (c == ' ' || c == '\n' || c == '\t' || c == '"' || c == Constants.CommentChar || c == Constants.RecordEndChar
				|| c == Constants.AttributeStartChar || c == Constants.TableStartChar || c == Constants.TableEndChar || c == Constants.ListStartChar
				|| c == Constants.ListEndChar)
				return true;
		}

		return false;
	}

	// Returns string contents with escape chars properly escaped according to Tyd rules.
	private static function escapeCharsEscapedForQuotedString(s: String): String {
		return s.replace("\"", "\\\"").replace(Constants.CommentChar, ("\\" + Constants.CommentChar));
	}

	private static function appendNodeIntro(node: TydCollection, sb: String, indent: Int): MultiReturn<Bool, String> {
		var appendedSomething = false;
		if (node.name != null) {
			sb += appendWithWhitespace(node.name, sb, indent, appendedSomething);
			appendedSomething = true;
		}
		if (node.attributeAbstract) {
			sb += appendWithWhitespace(Constants.AttributeStartChar + Constants.AbstractAttributeName, sb, indent, appendedSomething);
			appendedSomething = true;
		}
		if (node.attributeNoInherit) {
			sb += appendWithWhitespace(Constants.AttributeStartChar + Constants.NoInheritAttributeName, sb, indent, appendedSomething);
			appendedSomething = true;
		}
		if (node.attributeHandle != null) {
			sb += appendWithWhitespace(Constants.AttributeStartChar + Constants.HandleAttributeName + " " + node.attributeHandle, sb, indent,
				appendedSomething);
			appendedSomething = true;
		}
		if (node.attributeSource != null) {
			sb += appendWithWhitespace(Constants.AttributeStartChar + Constants.SourceAttributeName + " " + node.attributeSource, sb, indent,
				appendedSomething);
			appendedSomething = true;
		}

		return {
			val1: appendedSomething,
			val2: sb,
		}
	}

	private static function appendWithWhitespace(s: String, sb: String, indent: Int, appendedSomething: Bool): String {
		return sb + ((appendedSomething ? " " : indentString(indent)) + s);
	}

	private static function indentString(indent: Int): String {
		var s: String = "";
		for (_ in 0...indent) {
			s += "    ";
		}
		return s;
	}
}
