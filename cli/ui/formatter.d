module cli.ui.formatter;

class Formatter {
  static immutable string[string] SGR_MAP;
  shared static this() {
    SGR_MAP = [
      // Colors
      "red": "31",
      "green": "32",
      "yellow": "33",
      "blue": "94",
      "magenta": "35",
      "cyan": "36",
      // Style
      "bold": "1",
      "italic": "3",
      "underline": "4",
      "reset": "0",
      // Semantic
      "error": "31",
      "success": "32",
      "warning": "33",
      "info": "94",
      "command": "36"
    ];
  }

  string text;
  this(string text) {
    this.text = text;
  }

  auto format(bool enableColor = true, string[string] sgrMap = SGR_MAP) {
    
  }
}
