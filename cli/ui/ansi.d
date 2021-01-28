module cli.ui.ansi;
import std.conv: to;
import cli.ui.os: OS;

struct ANSI {
  static const ESC = '\x1b';

  @disable this();

  static auto control(wstring args, wstring cmd) {
    return ESC ~ "["w ~ args ~ cmd;
  }

  static auto sgr(wstring params) {
    return control(params, "m");
  }

  static auto cursorUp(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return ""w;
    }
    return control(n.to!wstring, "A");
  }

  static auto cursorDown(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return ""w;
    }
    return control(n.to!wstring, "B");
  }

  static auto cursorForward(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return ""w;
    }
    return control(n.to!wstring, "C"w);
  }

  static auto cursorBack(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return ""w;
    }
    return control(n.to!wstring, "D");
  }

  static auto cursorHorizontalAbsolute(ulong n = 1)
  in (n >= 0)
  {
    if(n == 0) {
      return ""w;
    }
    auto cmd = control(n.to!wstring, "G");
    if(OS.current.shiftCursorOnLineReset) {
      cmd ~= control("1", "D");
    }
    return cmd;
  }

  static auto showCursor() {
    return control("", "?25h");
  }

  static auto hideCursor() {
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
