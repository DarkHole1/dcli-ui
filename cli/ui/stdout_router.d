module cli.ui.stdout_router;
import std.stdio: File, stdout, stderr;

class StdoutRouter {
  this() @disable;

  static File stdout;
  static File stderr;

  shared static this() {
    this.stdout = stdout;
    this.stderr = stderr;
  }

  static auto nullify() {
    stdout.open("/dev/null", "w");
    stderr = stdout;
  }

  static auto restore() {
    stdout = this.stdout;
    stderr = this.stderr;
  }
}
