#!/bin/bash
# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: compile_MiniProject.sh
# Desc: This bash compiles MiniProject LaTeX file, to make it a PDF file in Results directory
# Date: 03 March 2020

pdflatex MiniProject.tex
pdflatex MiniProject.tex
bibtex MiniProject
pdflatex MiniProject.tex
pdflatex MiniProject.tex

## Cleanup
rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc

##Move the write up to the results directory
mv MiniProject.bbl ../Results/
mv MiniProject.blg ../Results/
mv MiniProject.pdf ../Results/

##Display the MiniProject.pdf
evince ../Results/MiniProject.pdf

