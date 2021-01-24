module cli.ui.terminal;
import core.sys.posix.sys.ioctl: wsz = winsize, ioctl, TIOCGWINSZ;
import std.stdio: stdout, writeln;
import std.typecons: tuple;

class Terminal {
  this() @disable;

  static const ushort DEFAULT_WIDTH = 80;
  static const ushort DEFAULT_HEIGHT = 24;

  static auto winsize() {
    wsz sz;
    auto res = ioctl(stdout.fileno(), TIOCGWINSZ, &sz);
    if(res != 0) {
      return tuple(DEFAULT_WIDTH, DEFAULT_HEIGHT);
    }
    return tuple(cast(const)sz.ws_col, cast(const)sz.ws_row);
  }
}
