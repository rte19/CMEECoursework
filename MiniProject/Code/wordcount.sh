#!/bin/bash
# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: wordcount_MiniProject.sh
# Desc: Calculates the wordcount of my write up and allows me to put this onto the document
# Date: 03 March 2020

#Count the words and put it into MiniProject.sum
texcount -1 -sum MiniProject.tex > MiniProject.sum

#Move MiniPrject.sum to the Data directory
mv MiniPrject.sum ../Data/