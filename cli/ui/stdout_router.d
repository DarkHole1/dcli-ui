module cli.ui.stdout_router;
import std.stdio: File, _stdout = stdout, _stderr = stderr;

class StdoutRouter {
  this() @disable;

  static File stdout;
  static File stderr;

  shared static this() {
    this.stdout = _stdout;
    this.stderr = _stderr;
  }

  static auto nullify() {
    _stdout.open("/dev/null", "w");
    _stderr = _stdout;
  }

  static auto restore() {
    _stdout = this.stdout;
    _stderr = this.stderr;
  }
}
