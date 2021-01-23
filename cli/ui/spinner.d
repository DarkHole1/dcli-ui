module cli.ui.spinner;
import core.sync.mutex: Mutex;
import std.range: zip, repeat, array;
import std.algorithm.iteration: map;
import std.math: floor, ceil;
import std.conv: to;
import std.datetime;
import cli.ui.os;
import cli.ui.color;
import cli.ui.ansi;
import std.stdio: write;
import core.thread.osthread: Thread;

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
    string title;
    bool allwaysFullRender;
    Thread thread;
    Mutex m;
    bool forceFullRender;
    Exception exception;
    bool success;

    this(string title, void delegate() block) {
      this.title = title;
      // TODO: Check for widgets
      this.allwaysFullRender = false;
      // TODO: Intercept output?
      this.thread = new Thread(block);
      this.m = new Mutex();
      this.forceFullRender = false;
      this.done = false;
      this.exception = null;
      this.success = false;
    }

    bool check() {
      if(this.done) {
        return true;
      }
      if(this.thread.isRunning) {
        return false;
      }
      this.done = true;
      this.success = true;
      auto exc = this.thread.join(false);
      if(exc != null) {
        this.exception = exc;
        this.success = false;
      }
      return true;
    }
  }

  auto add(string title, void delegate() block) {
    this.m.lock_nothrow();
    tasks ~= new Task(title, block);
    this.m.unlock_nothrow();
  }

  auto wait() {
    ulong idx = 0;
    while(true) {
      auto allDone = true;

      // TODO: Implement Terminal
      // auto width = Terminal.width;
      auto width = 80;

      this.m.lock_nothrow();
      // TODO: Implement raw?
      foreach(intIndex, task; this.tasks) {
        auto natIndex = intIndex + 1;
        auto taskDone = task.check;
        if(!taskDone) {
          allDone = false;
        }

        if(natIndex > this.consumedLines) {
          write(task.render(idx, true, width), "\n");
          this.consumedLines += 1;
        } else {
          auto offset = this.consumedLines - intIndex;
          auto moveTo = ANSI.cursorUp(offset) ~ "\r";
          auto moveFrom = "\r" ~ ANSI.cursorDown(offset);
          write(moveTo, task.render(idx, idx == 0, width), moveFrom);
        }
      }
      this.m.unlock_nothrow();

      if(allDone) {
        break;
      }

      idx = (idx + 1) % Spinner.GLYPHS.length;
      Spinner.index = idx;
      Thread.sleep(Spinner.PERIOD);
    }

    // TODO: Implement error checking
    return true;
  }

  auto debrief() {

  }
}

class Spinner {
  static ulong index = 0;

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

  static auto spin(string title, void delegate() block, bool autoDebrief = true) {
    auto sg = new SpinGroup(autoDebrief);
    sg.add(title, block);
    return sg.wait();
  }

  @disable this();
}
