Command-line tools written in [Gauche](https://practical-scheme.net/gauche/index.html),
which I actually use but by the same token it's a random assortment.

Install Gauche (it's also possible to build these as standalone executables),
add this directory to your PATH, and you can invoke, for example

```
files.scm -t swift
```

which will count the number of .swift files in the current directory and below.

- files.scm - counts files
- json.scm - checks valid json in each file
- links.scm - search for links
- lines.scm - counts lines in each file
- search.scm - search for text (regexp)
- size.scm - total of the file sizes

Use the -h option to print help for each command.
