#!/bin/bash
# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: This is combining $2 onto $1 and making it into $3
# Date: 1 Oct 2019

cat $1 > $3
cat $2 >> $3
echo "Merged File is"
cat $3

exit