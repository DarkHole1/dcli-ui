# dcli-ui
This is a port of ruby's [cli-ui](https://github.com/Shopify/cli-ui/) library.
## Usage
Now only spinner works:
```d
Spinner.spin("Title", { Thread.sleep(2.seconds); });

auto sg = new SpinGroup();
sg.add("Foo", { Thread.sleep(4.seconds); });
sg.add("Bar", { Thread.sleep(2.seconds); });
sg.add("Baz", { Thread.sleep(1.seconds); throw new Exception("Baz"); });
sg.wait();
```
![Example](/images/example.jpg)
