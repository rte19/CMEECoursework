#!/bin/bash
#!/bin/bash
# Author: Ryan Ellis ryan.ellis19@imperial.ac.uk
# Script: CompileLaTeX.sh
# Desc: This bash compiles LeTeX files, to make PDF files
# Date: 2 Oct 2019

pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &

## Cleanup
rm *~
rm *.aux
rm *.dvi
rm *.log
rm *.nav
rm *.out
rm *.snm
rm *.toc
