Command-line tools written in [Gauche](https://practical-scheme.net/gauche/index.html),
which I actually use but by the same token it's a random assortment.

Install Gauche (it's also possible to build these as standalone executables),
add these files to your PATH,

files.scm -t swift

which will count the number of .swift files in the current directory and below.

- files.scm - counts files
- json.scm - checks valid json in each file
- lines.scm - counts lines in each file
- size.scm - total of the file sizes
