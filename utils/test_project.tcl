set proj_file [ls *.mpf]
project open $proj_file
project compileall
project close
quit
