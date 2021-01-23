void main() {
  version(spinner) {
    spinner();
  }

  version(spingroup) {
    spingroup();
  }
}

void spinner() {
  import cli.ui.spinner;
  import core.thread.osthread;
  import std.datetime;

  Spinner.spin("Title", { Thread.sleep(2.seconds); });
}

void spingroup() {
  import cli.ui.spinner;
  import core.thread.osthread;
  import std.datetime;

  auto sg = new SpinGroup();
  sg.add("Foo", { Thread.sleep(4.seconds); });
  sg.add("Bar", { Thread.sleep(2.seconds); });
  sg.add("Baz", { Thread.sleep(1.seconds); throw new Exception("Baz"); });
  sg.wait();
}
