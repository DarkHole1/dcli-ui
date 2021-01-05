module cli.ui.spinner;
import core.sync.mutex: Mutex;
import std.datetime.systime: Clock, SysTime;

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
