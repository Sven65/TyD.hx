package tyd;

class Constants {
	// Constants - public
	public static var tydFileExtension: String = ".tyd";
	// Constants - internal
	public static var CommentChar: String = '#';
	public static var RecordEndChar: String = ';';
	public static var AttributeStartChar: String = '*';
	public static inline var HandleAttributeName: String = "handle";
	public static inline var SourceAttributeName: String = "source";
	public static var AbstractAttributeName: String = "abstract";
	public static var NoInheritAttributeName: String = "noinherit";
	public static var TableStartChar: String = '{';
	public static var TableEndChar: String = '}';
	public static var ListStartChar: String = '[';
	public static var ListEndChar: String = ']';
	public static var SymbolChars: String = "_-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
	public static var NullValueString: String = "null";
}
