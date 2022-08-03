Command-line tools written in [Gauche](https://practical-scheme.net/gauche/index.html), just started and this is what I've got so far:

Install Gauche, add these files to your PATH, and you can invoke, for example,

files.scm -t swift

will count all the .swift files in the current directory and below

lines.scm -t dart

will count all the lines in .dart files

size.scm

will sum up the size of all the files (ignoring hidden directories)

json.scm

will validate all the .json files

