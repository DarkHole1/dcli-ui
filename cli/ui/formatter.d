module cli.ui.formatter;
import Glyph

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
    // I didn't understand original logic of formatting so I implemented
    // my version here
    enum State { TEXT, SPECIAL, COLOR };
    State state = State.TEXT;

    string res = "";

    for(c; this.res) {
      final switch(state) {
        State.TEXT:
          if(c != '$') {
            res ~= c;
            break;
          }
          state = State.SPECIAL;
          break;
        State.SPECIAL:
          state = State.TEXT;
          if(c == '$' || c == '`' || c == '@') {
            res ~= c;
            break;
          }
          res ~= Glyph.lookup(c).to_s;
          break;
      }
    }
  }
}
