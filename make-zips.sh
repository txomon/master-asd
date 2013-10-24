#!/bin/bash
name=JAVIERD

for project in `ls *[0-9]* -d`; do
	cd $project
	files=`find . -name "*.vhd" -o -name "*.mpf" -o -name "*.png" -o -name "fichlectura.txt"| sed -e 's/^.*\///g'`
	number=`echo $project | sed -e 's/[a-zA-Z_]*//g'`
	zip -j $name-$number.zip $files
	cd ..
done;
