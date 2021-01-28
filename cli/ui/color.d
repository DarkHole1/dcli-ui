module cli.ui.color;
import cli.ui.ansi;

class Color {
  wstring sgr;
  wstring code;
  string name;
  this(wstring sgr, string name) {
    this.sgr = sgr;
    this.code = ANSI.sgr(sgr);
    this.name = name;
  }

  static const RED = new Color("31", "red");
  static const GREEN = new Color("32", "green");
  static const YELLOW = new Color("33", "yellow");
  static const BLUE = new Color("94", "blue");
  static const MAGENTA = new Color("35", "magenta");
  static const CYAN = new Color("36", "cyan");
  static const RESET = new Color("0", "reset");
  static const BOLD = new Color("1", "bold");
  static const WHITE = new Color("97", "white");
  static const GRAY = new Color("38;5;244", "gray");

  shared static this() {
    this.MAP = cast(immutable)[
      "red": Color.RED,
      "green": Color.GREEN,
      "yellow": Color.YELLOW,
      "blue": Color.BLUE,
      "magenta": Color.MAGENTA,
      "cyan": Color.CYAN,
      "reset": Color.RESET,
      "bold": Color.BOLD,
      "white": Color.WHITE,
      "gray": Color.GRAY
    ];
  }

  static auto lookup(string name) {
    // TODO: Add exception
    return MAP[name];
  }

  static auto available() {
    return MAP.keys;
  }

  static immutable const(Color)[string] MAP;
}
