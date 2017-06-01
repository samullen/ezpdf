# EZPDF

EZPDF is a command line tool to transform markdown files into PDF files.

## Installation

### Prerequisites

You will need to have wkhtmltopdf installed into /usr/local/bin. 

### Compiling

```
$ MIX_ENV=prod mix escript.build
```

copy the executable, `ezpdf`, to a `bin` directory near you.

## Configuration

ezpdf needs a `.ezpdfrc` file with the following information:

```
# .ezpdfrc
[config]
header = /path/to/header.html
footer = /path/to/footer.html
output = /path/to/output.pdf
```

These values aren't required. They can be overwritten by command line arguments,
or be ignored. 

## Other notes

This is a tool I wrote primarily to help me write proposals and estimates for
clients. It does what I need it to do, but probably won't be complete enough for
your needs. Feel free to fork it, rewrite it, praise it, or hate it. Just don't
ask me to maintain it beyond what I need.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with mix.exs file, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2017 Samuel Mullen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
