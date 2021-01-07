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
  Spinner.spin("Title", { Thread.sleep(5.seconds); });
  // writeln(Glyph.WARNING.to_s);
  // write(HIDE_CURSOR);
  // stdout.flush();
  // scope(exit) {
  //   write(START_LINE ~ ERASE_LINE, GLYPH_X);
  //   write(SHOW_CURSOR, '\n');
  //   stdout.flush();
  // }
  //
  // for (ulong i = 0; i < 100; i++) {
  //   write(START_LINE ~ ERASE_LINE, Spinner.GLYPHS[i % Spinner.GLYPHS.length]);
  //   stdout.flush();
  //   Thread.sleep(100.msecs);
  // }
}
