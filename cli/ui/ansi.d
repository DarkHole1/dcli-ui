module cli.ui.ansi;
import std.conv: to;
import cli.ui.os: OS;

struct ANSI {
  static const ESC = '\x1b';

  @disable this();

  static auto control(string args, string cmd) {
    return ESC ~ "[" ~ args ~ cmd;
  }

  static auto sgr(string params) {
    return control(params, "m");
  }

  static auto cursorUp(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return "";
    }
    return control(n.to!string, "A");
  }

  static auto cursorDown(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return "";
    }
    return control(n.to!string, "B");
  }

  static auto cursorForward(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return "";
    }
    return control(n.to!string, "C");
  }

  static auto cursorBack(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return "";
    }
    return control(n.to!string, "D");
  }

  static auto cursorHorizontalAbsolute(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return "";
    }
    auto cmd = control(n.to!string, "G");
    if(OS.current.shiftCursorOnLineReset) {
      cmd ~= control("1", "D");
    }
    return cmd;
  }

  static auto showCursor() {
    return control("", "?25h");
  }

  static auto showCursor() {
    return control("", "?25l");
  }

  static auto cursorSave() {
    return control("", "s");
  }

  static auto cursorRestore() {
    return control("", "u");
  }

  static auto nextLine() {
    return cursorDown ~ cursorHorizontalAbsolute;
  }

  static auto previousLine() {
    return cursorUp ~ cursorHorizontalAbsolute;
  }
}
