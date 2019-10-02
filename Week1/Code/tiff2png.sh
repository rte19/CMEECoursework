#!/bin/bash
# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: CountLines.sh
# Desc: converts tiff to png
# Date: 1 Oct 2019

for f in *.tif;
    do
        echo "Converting $f";
        convert "$f"  "$(basename "$f" .tif).jpg";
    done