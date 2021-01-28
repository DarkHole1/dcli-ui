void main() {
  version(spinner) {
    spinner();
  }

  version(spingroup) {
    spingroup();
  }

  version(printer) {
    printer();
  }

  version(terminal) {
    terminal();
  }

  version(stdout_router) {
    stdout_router();
  }

  version(formatter) {
    formatter();
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

void printer() {
  import cli.ui.printer;

  Printer.puts("{{x}} Ouch");
}

void terminal() {
  import cli.ui.terminal;
  import std.stdio;

  writeln("Width: ", Terminal.width, " cols, height: ", Terminal.height, " rows.");
}

void stdout_router() {
  import cli.ui.stdout_router;
  import std.stdio;

  writeln("Visible");
  StdoutRouter.nullify();
  writeln("Invisible");
  StdoutRouter.restore();
  writeln("Visible again");
}

void formatter() {
  import cli.ui.formatter;
  import std.stdio;

  writeln(new Formatter("`command:ls -la $x ouch! $$ $` $@").format());
}
