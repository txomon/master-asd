#!/bin/bash

cd $(git rev-parse --show-toplevel)

ex_code=0
for project in `ls *[0-9]* -d`; do
	cd $project
	vsim -keepstdout -runinit -c -do ../utils/test_project.tcl
	ex_code=$(expr $ex_code + $?)
	cd ..
done;

exit $ex_code
