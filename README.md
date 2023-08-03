Command-line tools written in [Gauche](https://practical-scheme.net/gauche/index.html),
which I actually use (e.g. JSON and link validation in [Talk Dim Sum](http://talkdimsum.com/)).

Install Gauche (it's also possible to build these as standalone executables),
add this directory to your PATH, and you can invoke, for example

```
files.scm -t swift
```

which will count the number of .swift files in the current directory and below.

- files.scm - counts files
- indent.scm - indents lisp files
- jsonvalid.scm - checks valid json in each file
- links.scm - search/check links
- lines.scm - counts lines in each file
- search.scm - search for text (regexp)
- size.scm - total of the file sizes
- urlfix.scm - repairs links
- libs - some reusable functions

Use the -h option to print help for each command.
