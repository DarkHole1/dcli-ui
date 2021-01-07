module cli.ui.spinner;
import core.sync.mutex: Mutex;
import std.range: zip, repeat, array;
import std.algorithm.iteration: map;
import std.math: floor, ceil;
import std.conv: to;
import std.datetime;
import cli.ui.os;
import cli.ui.color;

class SpinGroup {
  Mutex m;
  int consumedLines;
  bool autoDebrief;
  SpinGroup.Task[] tasks;
  SysTime start;
  this(bool autoDebrief = true) {
    this.m = new Mutex();
    this.consumedLines = 0;
    this.tasks = [];
    this.autoDebrief = autoDebrief;
    this.start = Clock.currTime();
  }

  class Task {
    // TODO: Implement
    this(string title, void delegate() block) {

    }
  }

  auto add(string title, void delegate() block) {
    this.m.lock_nothrow();
    tasks ~= new Task(title, block);
    this.m.unlock_nothrow();
  }

  auto wait() {

  }

  auto debrief() {

  }
}

class Spinner {
  static index = 0;

  static const PERIOD = 100.msecs;

  // TODO: Implement switching emoji
  // static if(OS.current.supportsEmoji) {
    static const RUNES = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
  // } else {
  //   static const RUNES = ['\\', '|', '/', '-', '\\', '|', '/', '-'];
  // }
  static const COLORS = Color.CYAN.code.repeat((RUNES.length / 2.0).ceil.to!int).array ~ Color.MAGENTA.code.repeat((RUNES.length / 2.0).floor.to!int).array;
  // static const GLYPHS = COLORS.zip(RUNES).map!(a => a[0] ~ a[1]).array;
  static const GLYPHS = [COLORS[0].to!(const(wstring)) ~ RUNES[0],
                         COLORS[1].to!(const(wstring)) ~ RUNES[1],
                         COLORS[2].to!(const(wstring)) ~ RUNES[2],
                         COLORS[3].to!(const(wstring)) ~ RUNES[3],
                         COLORS[4].to!(const(wstring)) ~ RUNES[4],
                         COLORS[5].to!(const(wstring)) ~ RUNES[5],
                         COLORS[6].to!(const(wstring)) ~ RUNES[6],
                         COLORS[7].to!(const(wstring)) ~ RUNES[7],
                         COLORS[8].to!(const(wstring)) ~ RUNES[8],
                         COLORS[9].to!(const(wstring)) ~ RUNES[9]];

  static auto currentRune() {
    return RUNES[index];
  }

  @disable this();
}
