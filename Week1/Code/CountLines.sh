#!/bin/bash
# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: CountLines.sh
# Desc: tells you the number of lines in the file of choice
# Date: 1 Oct 2019

NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
echo

exit