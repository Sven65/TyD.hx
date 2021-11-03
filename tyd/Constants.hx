package tyd;

class Constants {
	// Constants - public
	public static var tydFileExtension: String = ".tyd";
	// Constants - internal
	public static var CommentChar: String = '#';
	public static var RecordEndChar: String = ';';
	public static var AttributeStart: String = '*';
	public static var HandleAttributeName: String = "handle";
	public static var SourceAttributeName: String = "source";
	public static var AbstractAttributeName: String = "abstract";
	public static var NoInheritAttributeName: String = "noinherit";
	public static var TableStart: String = '{';
	public static var TableEnd: String = '}';
	public static var ListStart: String = '[';
	public static var ListEnd: String = ']';
	public static var staticSymbolChars: String = "_-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
	public static var staticNullValueString: String = "null";
}
