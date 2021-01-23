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
import cli.ui.glyph;
import std.stdio: write, stdout;
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
    wstring title;
    bool allwaysFullRender;
    Thread thread;
    Mutex m;
    bool forceFullRender;
    bool done;
    Throwable exception;
    bool success;

    this(wstring title, void delegate() block) {
      this.title = title;
      // TODO: Check for widgets
      this.allwaysFullRender = false;
      // TODO: Intercept output?
      this.thread = new Thread(block);
      this.thread.start();
      this.m = new Mutex();
      this.forceFullRender = false;
      this.done = false;
      this.exception = null;
      this.success = false;
    }

    auto check() {
      if(this.done) {
        return true;
      }
      if(this.thread.isRunning) {
        return false;
      }
      this.done = true;
      this.success = true;
      auto exc = this.thread.join(false);
      if(exc !is null) {
        this.exception = exc;
        this.success = false;
      }
      return true;
    }

    auto render(ulong index, bool force = true, int width = 80) {
      this.m.lock_nothrow();
      wstring res;
      if(force || this.allwaysFullRender || this.forceFullRender) {
        res = this.fullRender(index, width);
      } else {
        res = this.partialRender(index);
      }
      this.forceFullRender = false;
      this.m.unlock_nothrow();
      return res;
    }

    auto updateTitle(wstring newTitle) {
      this.m.lock_nothrow();
      // TODO: Check for widgets
      // this.allwaysFullRender = false;
      this.title = newTitle;
      this.forceFullRender = true;
      this.m.unlock_nothrow();
    }

    private:

    auto fullRender(ulong index, int width) {
      // TODO: Implement inset
      auto prefix = glyph(index) ~ Color.RESET.code ~ ' ';
      // TODO: Add truncation
      return prefix ~ this.title;
    }

    auto partialRender(ulong index) {
      return glyph(index) ~ cast(wstring)Color.RESET.code;
    }

    auto glyph(ulong index) {
      if(this.done) {
        if(this.success) {
          return cast(const(wstring)) Glyph.CHECK.to_s;
        }
        return cast(const(wstring)) Glyph.X.to_s;
      }
      return Spinner.GLYPHS[index];
    }
  }

  auto add(wstring title, void delegate() block) {
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
        // write("aaaa\n");
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
          stdout.flush();
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

  static auto spin(wstring title, void delegate() block, bool autoDebrief = true) {
    auto sg = new SpinGroup(autoDebrief);
    sg.add(title, block);
    return sg.wait();
  }

  @disable this();
}
