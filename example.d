import std.stdio;
import std.datetime;
import core.thread.osthread;
import std.uni;

import cli.ui.spinner;

const ESC = '\x1b';
const CSI = ESC ~ "[";
const ERASE_LINE = CSI ~ "K";
const START_LINE = CSI ~ "G";
const HIDE_CURSOR = CSI ~ "?25l";
const SHOW_CURSOR = CSI ~ "?25h";
const GLYPHS = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
const GLYPH_OK = '\u2713';
const GLYPH_X = '\u2717';

void main() {
  Spinner.spin("Title", { Thread.sleep(2.seconds); });
  auto sg = new SpinGroup();
  sg.add("Foo", { Thread.sleep(4.seconds); });
  sg.add("Bar", { Thread.sleep(2.seconds); });
  sg.add("Baz", { Thread.sleep(1.seconds); throw new Exception("Baz"); });
  sg.wait();
}
