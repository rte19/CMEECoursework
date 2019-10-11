#!/bin/bash
# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: tabtocsv.sh
# Desc: substitute the tabs in the files with commas
# saves the output into a .csv file
# Date: 1 Oct 2019

echo "Creating a comma delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
exit