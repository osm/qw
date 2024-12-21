#!/bin/sh

for d in $(ls -tlar | grep ^d | awk '{ print $NF }' | grep "^[a-z]"); do
	for f in $(ls $d/*.mvd); do
		mvdspawn "$f" | grep -i "$d" | head -n 1 >>first-spawns.csv
		mvdspawn "$f" | grep -i "$d" >>all-spawns.csv
	done
done

for f in $(ls *.csv); do
	sed 's/ua\.bps/bps/g' -i $f
	sed 's/ua\.peppe/peppe/g' -i $f
	sed 's/\. ParadokS/ParadokS/g' -i $f
	sed 's/tco\.\.\.\.\.\.\.\.\.axe/tco/g' -i $f
done
