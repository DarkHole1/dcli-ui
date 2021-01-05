module cli.ui.os;

struct OS {
  @disable this();

  static auto current() {
    version(OSX) {
      return new Mac();
    } else version(linux) {
      return new Linux();
    } else version(Windows) {
      return new Windows();
    } else {
      static assert(false, "Unsupported OS version");
    }
  }
}

class Mac {
  auto supportsEmoji() {
    return true;
  }

  auto supportsColorPrompt() {
    return true;
  }

  auto supportsArrowKeys() {
    return true;
  }

  auto shiftCursorOnLineReset() {
    return false;
  }
}

class Linux : Mac { }

class Windows {
  auto supportsEmoji() {
    return false;
  }

  auto supportsColorPrompt() {
    return false;
  }

  auto supportsArrowKeys() {
    return false;
  }

  auto shiftCursorOnLineReset() {
    return true;
  }
}
