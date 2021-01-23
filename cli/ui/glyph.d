module cli.ui.glyph;
import std.conv: wtext;
import cli.ui.os;
import cli.ui.color;

class Glyph {
  string handle;
  wstring symbol;
  const Color color;
  wstring plain;
  wstring fmt;
  this(string handle, wstring symbol, wstring plain, const Color color) {
    this.handle = handle;
    this.symbol = symbol;
    this.plain = plain;
    this.color = color;
    this.fmt = wtext("{{", color.name, ":", this.sym, "}}");
  }

  const auto sym() {
    if(OS.current.supportsEmoji) {
      return this.symbol;
    }
    return this.plain;
  }

  // TODO: More d-way name
  const auto to_s() {
    return this.color.code ~ this.sym ~ Color.RESET.code;
  }

  static const STAR = new Glyph("*", "\u2b51", "*", Color.YELLOW);
  static const INFO = new Glyph("i", "\U0001d4be", "i", Color.BLUE);
  static const QUESTION = new Glyph("?", "\u003f", "?", Color.BLUE);
  static const CHECK = new Glyph("v", "\u2713", "√", Color.GREEN);
  static const X = new Glyph("x", "\u2717", "X", Color.RED);
  static const BUG = new Glyph("b", "\U0001f41b", "!", Color.WHITE);
  static const CHEVRON = new Glyph(">", "\u00bb", "»", Color.YELLOW);
  static const HOURGLASS = new Glyph("H", "\u231b\ufe0e", "H", Color.BLUE);
  static const WARNING = new Glyph("!", "\u26a0\ufe0f", "!", Color.YELLOW);

  static const(Glyph)[string] MAP;
  shared static this() {
    MAP = [
      "*": Glyph.STAR,
      "i": Glyph.INFO,
      "?": Glyph.QUESTION,
      "v": Glyph.CHECK,
      "x": Glyph.X,
      "b": Glyph.BUG,
      ">": Glyph.CHEVRON,
      "H": Glyph.HOURGLASS,
      "!": Glyph.WARNING
    ];
  }

  auto lookup(string name) {
    // TODO: Add exception
    return MAP[name];
  }

  auto available() {
    return MAP.keys;
  }
}
