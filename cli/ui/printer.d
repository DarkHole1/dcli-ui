module cli.ui.printer;
import cli.ui.color: Color;
import std.stdio: File, stdout, writeln;

class Printer {
  bool puts(string msg, bool format = true, Color frameColor = null, bool graceful = true, File to = stdout) {
    // TODO: Implement formatting
    // TODO: Implement coloring
    // TODO: Implement graceful
    to.writeln(msg);
  }
}
