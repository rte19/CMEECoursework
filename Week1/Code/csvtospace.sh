#!/bin/bash
# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: csvtospace.sh
# Desc: substitute the commas in the file with spaces
# saves the output into a .ssv file
# Date: 11 Oct 2019

echo "Creating a space delimited version of $1 ..."
cat $1 | tr -s "," " " >> $1.txt
echo "Done!"
exit